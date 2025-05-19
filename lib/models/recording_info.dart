class RecordingInfo {
  final String filePath;
  final DateTime startTime;
  final Duration duration;

  RecordingInfo({
    required this.filePath,
    required this.startTime,
    required this.duration,
  });

  Map<String, dynamic> toJson() => {
        'filePath': filePath,
        'startTime': startTime.toIso8601String(),
        'duration': duration.inSeconds,
      };

  factory RecordingInfo.fromJson(Map<String, dynamic> json) => RecordingInfo(
        filePath: json['filePath'],
        startTime: DateTime.parse(json['startTime']),
        duration: Duration(seconds: json['duration']),
      );
}
