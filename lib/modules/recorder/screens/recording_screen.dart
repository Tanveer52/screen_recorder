import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/app_colors.dart';
import '../../../constants/strings.dart';
import '../../../providers/elapsed_time_provider.dart';
import '../../../providers/recording_controller_provider.dart';

class RecordingScreen extends ConsumerStatefulWidget {
  const RecordingScreen({super.key});

  @override
  ConsumerState<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends ConsumerState<RecordingScreen> {
  String _selectedDurationText = '15 seconds';

  Duration get _selectedDuration {
    switch (_selectedDurationText) {
      case '5 seconds':
        return const Duration(seconds: 5);
      case '30 seconds':
        return const Duration(seconds: 30);
      case '1 minute':
        return const Duration(minutes: 1);
      case '2 minutes':
        return const Duration(minutes: 2);
      default:
        return const Duration(seconds: 15);
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isRecording = ref.watch(recordingControllerProvider);
    final elapsed = ref.watch(elapsedTimeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Recording',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Please choose a duration for your recording',
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.white70,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: AppColors.background,
                  value: _selectedDurationText,
                  iconEnabledColor: AppColors.white,
                  style: const TextStyle(color: AppColors.white),
                  items: durations.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => _selectedDurationText = newValue);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isRecording
                  ? null
                  : () => ref
                      .read(recordingControllerProvider.notifier)
                      .startRecording(_selectedDuration),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gradientOrange,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Start Recording'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: isRecording
                  ? () => ref
                      .read(recordingControllerProvider.notifier)
                      .stopRecording()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gradientRed,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Stop Recording'),
            ),
            const SizedBox(height: 30),
            if (isRecording)
              Column(
                children: [
                  const Text(
                    'Recording...',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDuration(elapsed),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
