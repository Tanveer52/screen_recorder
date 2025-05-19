import 'package:screen_recorder/models/question.dart';

final List<Question> questions = [
  Question(
    questionText: 'What is the capital of France?',
    options: ['Berlin', 'Madrid', 'Paris', 'Rome'],
    correctIndex: 2,
  ),
  Question(
    questionText: 'What is Flutter primarily used for?',
    options: ['Web Scraping', 'App Development', 'Game Design', 'AI'],
    correctIndex: 1,
  ),
  Question(
    questionText: 'Which language is used by Flutter?',
    options: ['Kotlin', 'JavaScript', 'Dart', 'Swift'],
    correctIndex: 2,
  ),
  Question(
    questionText: 'Which widget is used for layouts in Flutter?',
    options: ['Scaffold', 'Column', 'Container', 'MaterialApp'],
    correctIndex: 1,
  ),
  Question(
    questionText: 'Who developed Flutter?',
    options: ['Facebook', 'Apple', 'Google', 'Amazon'],
    correctIndex: 2,
  ),
];

final List<String> durations = [
  '5 seconds',
  '15 seconds',
  '30 seconds',
  '1 minute',
  '2 minutes',
];
