import 'package:ai_voice_app/models/auth-register-login/user_model.dart';
import 'package:ai_voice_app/providers/providers.dart';
import 'package:ai_voice_app/providers/tokens.dart';
import 'package:ai_voice_app/screens/generation-pages/speech-transcription/speechTransription.dart';
import 'package:ai_voice_app/screens/home/widgets/generationCard.dart';
import 'package:ai_voice_app/screens/premium/premiumOfferScreen.dart';
import 'package:ai_voice_app/screens/profile/profileScreen.dart';
import 'package:ai_voice_app/services/credits/premiumController.dart';
import 'package:ai_voice_app/services/db-services-firebase/firestore_db.dart';
import 'package:ai_voice_app/styles.dart';
import 'package:ai_voice_app/widgets/appBarBackButton.dart';
import 'package:ai_voice_app/widgets/generalCustomButton.dart';
import 'package:ai_voice_app/widgets/generalIconContainer.dart';
import 'package:ai_voice_app/widgets/texts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ai_voice_app/screens/generation-pages/speech-translate/speech_translate.dart';
import 'package:ai_voice_app/screens/generation-pages/textToSpeech/textToSpeech.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ConnectivityResult connectionStatus = ConnectivityResult.none;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _checkInternetConnection();
    // Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   setState(() {
    //     connectionStatus = result;
    //   });
    // });
  }

  // Future<void> _checkInternetConnection() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   setState(() {
  //     connectionStatus = connectivityResult;
  //   });

  //   if (connectivityResult == ConnectivityResult.none) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => NoInternetScreen()),
  //     );
  //   } else {
  //     print("internete bağlı değil değil");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.scaffoldBackground,
      appBar: AppBar(
        //centerTitle: true,
        title: Text(
          "Revoicer App",
          style: Styles.normalTextStyle.copyWith(fontSize: 20),
        ),
        leading: const Icon(
          Icons.voice_chat,
          color: Styles.textAndIconColorWhite,
          size: 35,
        ),
        backgroundColor: Styles.scaffoldBackground,
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final tokenBalance = ref.watch(tokenAmountAsyncProvider);
              return tokenBalance.when(
                data: (data) {
                  return Container(
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Styles.iconButtonBgColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(child: AppText.normalWhite(text: "T: $data")),
                  );
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
                error: (error, stackTrace) {
                  return const SizedBox();
                },
              );
            },
          ),
          IconContainer(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InternetVarMi(),
                ),
              );
            },
            icon: Icons.person,
            color: Styles.iconButtonBgColor,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Styles.smallSpacer,
          Consumer(
            builder: (context, ref, child) {
              String? userid = ref.read(useridProvider);
              return FutureBuilder(
                future: FirestoreDb().getCurrentUserInfo(userid!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  return AppText.normalWhite(
                      text: "Hi👋 ${snapshot.data?.fullName}");
                },
              );
            },
          ),
          Styles.smallSpacer,
          GenerationCard(
            title: "Text To Speech...",
            headerIcon: Icons.voice_chat,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TextToSpeech(),
                ),
              );
            },
          ),
          GenerationCard(
            title: "Speech Transcription",
            headerIcon: Icons.transcribe,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SpeechToText(),
                ),
              );
            },
          ),
          GenerationCard(
            title: "Translate Voices",
            headerIcon: Icons.translate,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SpeechTranslate(),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("no internet"),
        leading: AppBarBackButton(),
      ),
    );
  }
}

class InternetVarMi extends StatefulWidget {
  const InternetVarMi({super.key});

  @override
  State<InternetVarMi> createState() => _InternetVarMiState();
}

class _InternetVarMiState extends State<InternetVarMi> {
  ConnectivityResult connectionStatus = ConnectivityResult.none;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkInternetConnection();
    // Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   setState(() {
    //     connectionStatus = result;
    //   });
    // });
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      connectionStatus = connectivityResult;
    });

    if (connectivityResult == ConnectivityResult.none) {
      print("internet yok");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NoInternetScreen()),
      );
    } else {
      print("internete bağlı değil değil");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBarBackButton(),
      ),
      body: Center(
        child: Text(" bağlantı : $connectionStatus"),
      ),
    );
  }
}
