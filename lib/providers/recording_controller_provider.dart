import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen_recorder/providers/recordings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/recording_info.dart';
import 'elapsed_time_provider.dart';

final recordingControllerProvider =
    StateNotifierProvider<RecordingController, bool>((ref) {
  return RecordingController(ref);
});

class RecordingController extends StateNotifier<bool> {
  final Ref ref;
  Timer? _timer;
  DateTime? _startTime;

  late final RecordingsNotifier _recordingsNotifier =
      ref.read(recordingsNotifierProvider.notifier);

  RecordingController(this.ref) : super(false);

  Future<void> _requestPermissions() async {
    final result = await [Permission.storage, Permission.microphone].request();
    if (!result[Permission.storage]!.isGranted ||
        !result[Permission.microphone]!.isGranted) {
      throw Exception('Permissions not granted');
    }
  }

  Future<void> startRecording(Duration maxDuration) async {
    await _requestPermissions();
    final fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}';

    final started = await FlutterScreenRecording.startRecordScreen(
      fileName,
      titleNotification: 'Recording Screen',
      messageNotification: 'Recording your Flutter app screen...',
    );

    if (!started) throw Exception('Recording failed to start');

    _startTime = DateTime.now();
    ref.read(elapsedTimeProvider.notifier).state = Duration.zero;
    state = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newDuration =
          ref.read(elapsedTimeProvider) + const Duration(seconds: 1);
      ref.read(elapsedTimeProvider.notifier).state = newDuration;

      if (newDuration >= maxDuration) {
        stopRecording();
      }
    });
  }

  Future<void> stopRecording() async {
    _timer?.cancel();
    final path = await FlutterScreenRecording.stopRecordScreen;

    state = false;

    if (!File(path).existsSync()) throw Exception('Recording file not found');

    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime!);

    final dir = await getApplicationDocumentsDirectory();
    final savedPath = '${dir.path}/${path.split('/').last}';
    await File(path).copy(savedPath);

    final info = RecordingInfo(
      filePath: savedPath,
      startTime: _startTime!,
      duration: duration,
    );

    await _saveRecordingInfo(info);
  }

  Future<void> _saveRecordingInfo(RecordingInfo info) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('recordings') ?? [];
    list.add(jsonEncode(info.toJson()));
    await prefs.setStringList('recordings', list);
    _recordingsNotifier.addRecording(info);
  }
}
