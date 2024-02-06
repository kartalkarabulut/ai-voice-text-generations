import 'package:ai_voice_app/providers/providers.dart';
import 'package:ai_voice_app/providers/tokens.dart';
import 'package:ai_voice_app/screens/generation-pages/speech-transcription/allTranscriptions.dart';
import 'package:ai_voice_app/services/auth/auth_services.dart';
import 'package:ai_voice_app/services/generations_controller.dart';
import 'package:ai_voice_app/styles.dart';
import 'package:ai_voice_app/widgets/appBarBackButton.dart';
import 'package:ai_voice_app/widgets/generalCustomButton.dart';
import 'package:ai_voice_app/widgets/inputField.dart';
import 'package:ai_voice_app/widgets/texts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpeechToText extends StatefulWidget {
  const SpeechToText({super.key});

  @override
  State<SpeechToText> createState() => _SpeechToTextState();
}

class _SpeechToTextState extends State<SpeechToText> {
  String returnedValue = "You didn't Pick a File";
  String? selectedFilePath = "You didn't Pick a File";
  TextEditingController transcriptionNameController = TextEditingController();
  bool transcriptionOnProcess = false;

  Future<String?> _pickFile() async {
    String? filePath = await FilePicker.platform
        .pickFiles(type: FileType.audio)
        .then((result) {
      if (result != null) {
        return result.files.single.path;
      }
      return null;
    });

    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        leading: AppBarBackButton(),
        title: AppText.normalWhite(text: "Speech Transcription"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllTranscriptions()));
            },
            icon: const Icon(
              Icons.text_snippet_rounded,
              color: Styles.textAndIconColorWhite,
              size: 40,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Styles.mediumSpacer,
              GeneralButton(
                buttonText: "Pick A Mp3 File",
                onPressed: () async {
                  selectedFilePath = await _pickFile();
                },
              ),
              Styles.mediumSpacer,
              SmallInputField(
                inputController: transcriptionNameController,
                hintText: "Transcription Name",
              ),
              Styles.mediumSpacer,
              SelectableText(
                selectedFilePath ?? "You didn't Select a File",
                style: Styles.normalTextStyle,
              ),
              Styles.mediumSpacer,
              Consumer(
                builder: (context, ref, child) {
                  String? userid = ref.read(useridProvider);
                  final tokenBalance =
                      ref.watch(tokenAmountAsyncProvider).value;
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.buttonColor,
                      ),
                      onPressed: () async {
                        int tokenCost = await GenerationController()
                            .secondsToToken(selectedFilePath!)
                            .then((value) => value.toInt());

                        if (tokenCost <= tokenBalance! &&
                            selectedFilePath != null) {
                          setState(() {
                            transcriptionOnProcess = true;
                          });
                          String text =
                              await GenerationController().speechToText(
                            selectedFilePath!,
                            transcriptionNameController.text,
                            context,
                            userid!,
                          );

                          await ref
                              .read(tokenAmountAsyncProvider.notifier)
                              .decreaseTokenAmount(tokenCost);
                          setState(() {
                            returnedValue = text;
                            transcriptionOnProcess = false;
                          });
                        } else {
                          showSnackBar(context, "tken limit isnt enouhg");
                        }
                      },
                      child: transcriptionOnProcess
                          ? const CircularProgressIndicator()
                          : const Text(
                              "Send file",
                              style: Styles.normalTextStyle,
                            ),
                    ),
                  );
                },
              ),
              Styles.mediumSpacer,
              SelectableText(
                returnedValue,
                style: Styles.normalTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
