import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_recorder/models/recording_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

final recordingsNotifierProvider =
    StateNotifierProvider<RecordingsNotifier, List<RecordingInfo>>(
  (ref) => RecordingsNotifier(),
);

class RecordingsNotifier extends StateNotifier<List<RecordingInfo>> {
  RecordingsNotifier() : super([]) {
    loadRecordings();
  }

  Future<void> loadRecordings() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('recordings') ?? [];

    state = list.map((recordingString) {
      final Map<String, dynamic> map = jsonDecode(recordingString);
      return RecordingInfo.fromJson(map);
    }).toList();
  }

  Future<void> addRecording(RecordingInfo info) async {
    state = [...state, info];
  }

  Future<void> clearAllRecordings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recordings');
    state = [];
  }
}
