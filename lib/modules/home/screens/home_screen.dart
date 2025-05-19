import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:screen_recorder/modules/recorder/screens/playback_screen.dart';
import 'package:screen_recorder/modules/recorder/screens/recording_screen.dart';

import '../../../config/app_colors.dart';
import '../../../providers/recordings_provider.dart';
import '../../quiz/screens/quiz_screen.dart';
import '../widgets/featured_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _goToRecordingScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RecordingScreen()),
    );
  }

  void _goToQuizScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const QuizScreen()),
    );
  }

  void _goToPlaybackScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PlaybackScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recordings = ref.watch(recordingsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '— Hi! 👋 Go record?',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FeatureCard(
                      icon: Icons.emergency_recording,
                      title: 'Screen Recording',
                      subtitle: 'Record your screen and save it',
                      onTap: _goToRecordingScreen,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FeatureCard(
                      icon: Icons.quiz,
                      title: 'Quiz',
                      subtitle: 'Take a quiz to test your knowledge',
                      onTap: _goToQuizScreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _goToPlaybackScreen,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        recordings.length.toString(),
                        style: TextStyle(color: AppColors.white, fontSize: 16),
                      ),
                      Icon(Icons.folder_open_rounded, color: AppColors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
