class GeneratedSpech {
  GeneratedSpech(
      {required this.generationName,
      required this.storageUrl,
      required this.generationTime});

  factory GeneratedSpech.fromJson(Map<String, dynamic> json) {
    return GeneratedSpech(
      generationName: json['generationName'] as String,
      storageUrl: json['storageUrl'] as String,
      generationTime: DateTime.parse(json['generationTime'] as String),
    );
  }

  String generationName;
  DateTime generationTime;
  String storageUrl;

  Map<String, dynamic> toJson() {
    return {
      'generationName': generationName,
      'storageUrl': storageUrl,
      'generationTime': generationTime.toIso8601String(),
    };
  }
}
