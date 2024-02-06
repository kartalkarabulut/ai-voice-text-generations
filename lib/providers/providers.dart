import 'package:ai_voice_app/models/auth-register-login/user_model.dart';
import 'package:ai_voice_app/providers/tokens.dart';
import 'package:ai_voice_app/services/credits/premiumController.dart';
import 'package:ai_voice_app/services/db-services-firebase/firestore_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aiVoicesProvider = Provider<List<String>>((ref) {
  List<String> voiceNames = [
    "alloy",
    "echo",
    "fable",
    "onyx",
    "nova",
    "shimmer"
  ];
  return voiceNames;
});

final authProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final useridProvider = Provider<String?>((ref) {
  return FirebaseAuth.instance.currentUser!.uid;
});

final transcriptedTextProvider = FutureProvider((ref) async {
  String? userid = ref.read(useridProvider);
  var newWaleue = await FirestoreDb().fetchTranscriptedTexts(userid!);
  return newWaleue;
});

final translatedTextProvider = FutureProvider((ref) async {
  try {
    String? userid = ref.read(useridProvider);
    return await FirestoreDb().fetchTranslatedTexts(userid!);
  } catch (e) {
    print("veri çekme hatası::::: $e");
    throw e;
  }
});

final generatedSpeechProvider = FutureProvider((ref) async {
  try {
    String? userid = ref.read(useridProvider);
    final firestoreDb = ref.watch(firestoreDbProvider);
    return firestoreDb.fetchGeneratedSpeechs(userid!);
  } catch (e) {
    print("veri çekme hatasi::L::::: $e");
    throw e;
  }
});
final firestoreDbProvider = Provider<FirestoreDb>((ref) {
  return FirestoreDb(); // declared elsewhere
});

final userInfoProvider = FutureProvider<UserModel>((ref) async {
  String? userId = ref.watch(useridProvider);

  return await FirestoreDb().getCurrentUserInfo(userId!);
});

final tokenAmountFutureProvider = FutureProvider<int>((ref) async {
  String? userId = ref.watch(useridProvider);
  return await PremiumController().getTokenAmountOfUser(userId!);
});
