import 'dart:io';
import 'package:ai_voice_app/models/audio-voice/transcriptedTextModel.dart';
import 'package:ai_voice_app/models/audio-voice/translatedtext.dart';
import 'package:ai_voice_app/models/audio-voice/voice_model.dart';
import 'package:ai_voice_app/models/auth-register-login/user_model.dart';
import 'package:ai_voice_app/providers/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreDb {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future saveUserData(UserModel user) async {
    try {
      var userCollection = firebaseFirestore.collection("users");
      await userCollection.doc(user.userid).set(user.toJson());
    } catch (e) {}
  }

  Future saveGeneratedTranscriptionToDb(
      TranscriptedText generatedText, String userid) async {
    try {
      var usersCollection = firebaseFirestore.collection("users");
      var transcriptionCollection =
          await usersCollection.doc(userid).collection("transcriptedTexts");
      await transcriptionCollection
          .doc(generatedText.transcriptionName)
          .set(generatedText.toJson());
      print("Yazı kaydedildi");
    } catch (e) {
      return e;
    }
  }

  Future saveGeneratedTranslateToDb(
      TranslatedText translatedText, String userid) async {
    try {
      var usersCollection = firebaseFirestore.collection("users");
      var transcriptionCollection =
          await usersCollection.doc(userid).collection("translatedTexts");
      await transcriptionCollection
          .doc(translatedText.translationName)
          .set(translatedText.toJson());
      print("Yazı kaydedildi");
    } catch (e) {
      return e;
    }
  }

  Future saveGeneratedSpeechInfoToFirestore(
      GeneratedSpech generatedSpech, String userid) async {
    CollectionReference userCollection = firebaseFirestore.collection("users");
    CollectionReference speechReference =
        userCollection.doc(userid).collection("generatedSpeechsInfos");

    await speechReference
        .doc(generatedSpech.generationName)
        .set(generatedSpech.toJson());
  }

  Future saveGeneratedSpeechToStorageDb(File generatedVoiceFile,
      String fileName, String generationName, String userid) async {
    try {
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child("voices_generated_from_text/$userid/$fileName");
      await storageReference.putFile(generatedVoiceFile);

      String downloadUrl = await storageReference.getDownloadURL();
      saveGeneratedSpeechInfoToFirestore(
          GeneratedSpech(
              generationName: generationName,
              storageUrl: downloadUrl,
              generationTime: DateTime.now()),
          userid);
    } catch (e) {
      print(e);
    }
  }

  //Fetch all transcripted texts
  Future<List<TranscriptedText>> fetchTranscriptedTexts(String userid) async {
    try {
      var usersCollection = firebaseFirestore.collection("users");
      var transcriptionCollection = await usersCollection
          .doc(userid)
          .collection("transcriptedTexts")
          .get();

      return transcriptionCollection.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return TranscriptedText.fromJson(data);
      }).toList();
    } catch (e) {
      print("veri çekilirken hata oluştu $e");
      throw e;
    }
  }

  Future<List<TranslatedText>> fetchTranslatedTexts(String userid) async {
    try {
      var usersCollection = firebaseFirestore.collection("users");
      var transcriptionCollection =
          await usersCollection.doc(userid).collection("translatedTexts").get();

      return transcriptionCollection.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return TranslatedText.fromJson(data);
      }).toList();
    } catch (e) {
      print("veri çekilirken hata oluştu $e");
      throw e;
    }
  }

  Future<List<GeneratedSpech>> fetchGeneratedSpeechs(String userid) async {
    try {
      var usersCollection = firebaseFirestore.collection("users");
      var generatedSpeechCollection = await usersCollection
          .doc(userid)
          .collection("generatedSpeechsInfos")
          .get();
      return generatedSpeechCollection.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return GeneratedSpech.fromJson(data);
      }).toList();
    } catch (e) {
      print("veri çekilirken hata oluştu $e");
      throw e;
    }
  }

  Future<UserModel> getCurrentUserInfo(String userId) async {
    try {
      var snapshot =
          await firebaseFirestore.collection("users").doc(userId).get();

      return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    } catch (e) {
      print("errororo::: $e");
      throw e;
    }
  }

  Future<UserType> getCurrentUserType(String userId) async {
    try {
      var snapshot =
          await firebaseFirestore.collection("users").doc(userId).get();

      UserModel user =
          UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      print("kullanıcimizin tipi : ${user.userType}");
      return user.userType;
    } catch (e) {
      print("errororo::: $e");
      throw e;
    }
  }

  Stream<UserType> getCurrentUserTypeStream(String userId) {
    var userDocument =
        firebaseFirestore.collection("users").doc(userId).snapshots();

    return userDocument.map((snapshot) {
      if (snapshot.exists) {
        UserModel user =
            UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
        print("Kullanıcının tipi: ${user.userType}");
        return user.userType;
      } else {
        // Kullanıcı dokümanı yoksa veya hata oluşursa varsayılan değeri döndür
        return UserType.normal;
      }
    });
  }
}

final funcprovider = Provider((ref) async {
  String? userId = ref.watch(useridProvider);
  return await FirestoreDb().getCurrentUserType(userId!);
});
final userTypeProvider = FutureProvider((ref) {
  var userType = ref.watch(funcprovider);
  print(userType);
  return userType;
});

final userTypeStreamProvider = StreamProvider<UserType>((ref) {
  // useridProvider'ı kullanarak userId'i al
  String? userId = ref.read(useridProvider);

  // getCurrentUserTypeStream fonksiyonunu kullanarak Stream'i oluştur
  return FirestoreDb().getCurrentUserTypeStream(userId!);
});
