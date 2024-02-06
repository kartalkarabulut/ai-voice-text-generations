class TranslatedText {
  TranslatedText({
    required this.translatedText,
    required this.translationName,
    required this.translationTime,
  });

  factory TranslatedText.fromJson(Map<String, dynamic> json) => TranslatedText(
        translatedText: json['translatedText'],
        translationName: json['translationName'],
        translationTime: DateTime.parse(json['translationTime']),
      );

  String translatedText;
  String translationName;
  DateTime translationTime;

  Map<String, dynamic> toJson() => {
        'translatedText': translatedText,
        'translationName': translationName,
        'translationTime': translationTime.toIso8601String(),
      };
}
