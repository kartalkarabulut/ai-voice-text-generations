import 'package:ai_voice_app/providers/providers.dart';
import 'package:ai_voice_app/providers/tokens.dart';
import 'package:ai_voice_app/screens/generation-pages/speech-translate/allTranslations.dart';
import 'package:ai_voice_app/services/auth/auth_services.dart';
import 'package:ai_voice_app/services/generations_controller.dart';
import 'package:ai_voice_app/styles.dart';
import 'package:ai_voice_app/widgets/appBarBackButton.dart';
import 'package:ai_voice_app/widgets/generalCustomButton.dart';
import 'package:ai_voice_app/widgets/inputField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpeechTranslate extends StatefulWidget {
  const SpeechTranslate({super.key});

  @override
  State<SpeechTranslate> createState() => _SpeechTranslateState();
}

class _SpeechTranslateState extends State<SpeechTranslate> {
  String? translatedText;
  TextEditingController translationNameController = TextEditingController();
  bool translationOnProcces = false;

  String? filePath;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: AppBarBackButton(),
        title: Text(
          "Translate Voice",
          style: Styles.normalTextStyle.copyWith(fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              //await FirebaseAuth.instance.signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllTranslations()));
            },
            icon: const Icon(
              Icons.text_snippet_rounded,
              size: 40,
              color: Styles.textAndIconColorWhite,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Styles.mediumSpacer,
              GeneralButton(
                buttonText: "Pick A Voice File",
                onPressed: () async {
                  filePath = await GenerationController().pickFile();

                  setState(() {});
                },
              ),
              Styles.mediumSpacer,
              SelectableText(
                filePath ?? "You didn't Pick a File",
                style: Styles.normalTextStyle,
              ),
              Styles.mediumSpacer,
              SmallInputField(
                  inputController: translationNameController,
                  hintText: "Translation Name"),
              Styles.mediumSpacer,
              Consumer(
                builder: (context, ref, child) {
                  String? userid = ref.read(useridProvider);
                  int tokenBalance = ref.watch(tokenAmountAsyncProvider).value!;
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (filePath != null) {
                          int tokenCost = await GenerationController()
                              .secondsToToken(filePath!)
                              .then((value) => value.toInt());

                          if (tokenCost <= tokenBalance) {
                            setState(() {
                              translationOnProcces = true;
                            });

                            translatedText = await GenerationController()
                                .speechTranslateToEnglish(
                                    userid!,
                                    translationNameController.text,
                                    filePath!,
                                    context);

                            await ref
                                .read(tokenAmountAsyncProvider.notifier)
                                .decreaseTokenAmount(tokenCost);

                            setState(() {
                              translationOnProcces = false;
                            });
                          } else {
                            showSnackBar(context, "Token Limit isnt enough");
                          }
                        }
                      },
                      child: translationOnProcces
                          ? const CircularProgressIndicator()
                          : Text(
                              "Translate",
                              style:
                                  Styles.normalTextStyle.copyWith(fontSize: 25),
                            ),
                    ),
                  );
                },
              ),
              Styles.mediumSpacer,
              SelectableText(
                translatedText ?? "You didn't Translate ",
                style: Styles.normalTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
