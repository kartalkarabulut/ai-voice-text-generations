import 'dart:convert';
import 'dart:io';
import 'package:ai_voice_app/constans/string_constants.dart';
import 'package:ai_voice_app/models/audio-voice/transcriptedTextModel.dart';
import 'package:ai_voice_app/models/audio-voice/translatedtext.dart';
import 'package:ai_voice_app/services/db-services-firebase/firestore_db.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class GenerationController {
  //Translate selected voice and save to firestore
  Future<String> speechToText(String selectedFilePath, String transcriptionName,
      BuildContext context, String userid) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(transcriptionUrl))
        ..headers['Authorization'] = 'Bearer $openaiApiKey'
        ..headers['Content-Type'] = 'multipart/form-data'
        ..files.add(await http.MultipartFile.fromPath('file', selectedFilePath))
        ..fields['model'] = 'whisper-1';

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      var text = jsonResponse["text"];

      var transcriptedText = TranscriptedText(
          transcriptedText: text,
          transcriptionName: transcriptionName,
          transcriptionTime: DateTime.now());

      ///Save transcripted voice's text to firestore
      if (text != null) {
        try {
          await FirestoreDb()
              .saveGeneratedTranscriptionToDb(transcriptedText, userid);
        } catch (e) {
          throw e;
        }
      }
      return text;
    } catch (e) {
      throw e;
    }
  }

  //Pick A File
  Future<String?> pickFile() async {
    String? filePath = await FilePicker.platform.pickFiles().then((result) {
      if (result != null && result.files.isNotEmpty) {
        return result.files.single.path;
      }
      return null;
    });

    return filePath;
  }

  //Speech to English
  Future speechTranslateToEnglish(String userid, String translationName,
      String selectedFilePath, BuildContext context) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(translationUrl))
        ..headers["Authorization"] = 'Bearer $openaiApiKey'
        ..headers['Content-Type'] = 'multipart/form-data'
        ..files.add(await http.MultipartFile.fromPath('file', selectedFilePath))
        ..fields['model'] = 'whisper-1';
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      var text = jsonResponse['text'];

      ///Save translated voice's text to firestore
      if (text != null) {
        try {
          await FirestoreDb().saveGeneratedTranslateToDb(
            TranslatedText(
              translatedText: text,
              translationName: translationName,
              translationTime: DateTime.now(),
            ),
            userid,
          );
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Error: $e")));
        }
      }
      return text;
    } catch (e) {
      throw e;
    }
  }

  //text to speech
  Future<void> loadAndPlaySpeech(
      BuildContext context,
      String content,
      String voice,
      AudioPlayer audioPlayer,
      String generationName,
      String userid) async {
    final Map<String, String> headers = {
      "Authorization": "Bearer $openaiApiKey",
      "Content-Type": "application/json",
    };

    final Map<String, dynamic> requestBody = {
      "model": "tts-1",
      "input": content,
      "voice": voice,
    };

    final http.Response response = await http.post(
      Uri.parse(textToSpeechUrl),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print("istek başarılı oldu");

      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String filename = '${generationName}_$timestamp.mp3';

      Directory? downloadsDir = await getDownloadsDirectory();

      if (downloadsDir != null) {
        final String localFilePath = '${downloadsDir.path}/$filename';
        File(localFilePath).writeAsBytesSync(response.bodyBytes);
        print("kaydedilen yer = ${localFilePath}");

        //File.fromRawPath(Uint8List.fromList(response.bodyBytes))
        await FirestoreDb().saveGeneratedSpeechToStorageDb(
            File(localFilePath), filename, generationName, userid);

        await audioPlayer.setAudioSource(
          ConcatenatingAudioSource(children: [
            AudioSource.uri(Uri.file(localFilePath)),
          ]),
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
            content: Text("Generated Audio Saved To : $localFilePath")));
      }
    } else {
      // Handle error
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<double> secondsToToken(String filePath) async {
    AudioPlayer temporaryPlayer = AudioPlayer();
    await temporaryPlayer.setFilePath(filePath);
    int durationInSeconds = await temporaryPlayer.duration!.inSeconds;
    print("kaç aniye kk:: $durationInSeconds");
    return durationInSeconds * 3.35;
  }
}
