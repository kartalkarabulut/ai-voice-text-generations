class TranscriptedText {
  TranscriptedText({
    required this.transcriptedText,
    required this.transcriptionName,
    required this.transcriptionTime,
  });

  factory TranscriptedText.fromJson(Map<String, dynamic> json) =>
      TranscriptedText(
        transcriptedText: json['transcriptedText'],
        transcriptionName: json['transcriptionName'],
        transcriptionTime: DateTime.parse(json['transcriptionTime']),
      );

  String transcriptedText;
  String transcriptionName;
  DateTime transcriptionTime;

  Map<String, dynamic> toJson() => {
        'transcriptedText': transcriptedText,
        'transcriptionName': transcriptionName,
        'transcriptionTime': transcriptionTime.toIso8601String(),
      };
}
