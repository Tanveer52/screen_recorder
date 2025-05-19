import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../config/app_colors.dart';
import '../../../providers/recordings_provider.dart';
import 'video_player_screen.dart';

class PlaybackScreen extends ConsumerStatefulWidget {
  const PlaybackScreen({super.key});

  @override
  ConsumerState<PlaybackScreen> createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends ConsumerState<PlaybackScreen> {
  late final RecordingsNotifier _recordingsNotifier =
      ref.read(recordingsNotifierProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _recordingsNotifier.loadRecordings();
    });
  }

  String _formatDuration(Duration duration) {
    return '${duration.inMinutes}m ${(duration.inSeconds % 60).toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    final recordings = ref.watch(recordingsNotifierProvider);

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
          'Recorded Videos',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (recordings.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.delete_forever,
                color: AppColors.white,
              ),
              tooltip: 'Clear All',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppColors.card,
                    title: const Text('Clear All Recordings',
                        style: TextStyle(color: AppColors.white)),
                    content: const Text(
                      'Are you sure you want to delete all recordings?',
                      style: TextStyle(color: AppColors.white),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: AppColors.gradientRed),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await _recordingsNotifier.clearAllRecordings();
                }
              },
            ),
        ],
      ),
      body: recordings.isEmpty
          ? const Center(
              child: Text('No recordings found',
                  style: TextStyle(color: AppColors.white70)),
            )
          : ListView.builder(
              itemCount: recordings.length,
              itemBuilder: (context, index) {
                final rec = recordings[index];
                final file = File(rec.filePath);
                final name = file.path.split('/').last;
                final exists = file.existsSync();
                final modified = exists ? file.lastModifiedSync() : null;
                final duration = rec.duration;

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      name,
                      style: const TextStyle(
                          color: AppColors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      exists
                          ? 'Recorded: ${DateFormat.yMMMd().add_jm().format(modified!)}\nDuration: ${_formatDuration(duration)}'
                          : 'File not found',
                      style: const TextStyle(
                          color: AppColors.white70, fontSize: 13),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gradientOrange,
                      ),
                      onPressed: exists
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      VideoPlayerScreen(videoFile: file),
                                ),
                              );
                            }
                          : null,
                      child: const Text('Play'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
