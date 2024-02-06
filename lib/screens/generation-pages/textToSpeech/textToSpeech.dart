import 'package:ai_voice_app/providers/tokens.dart';
import 'package:ai_voice_app/screens/generation-pages/textToSpeech/allVoiceGenerations.dart';
import 'package:ai_voice_app/services/voice/audio_controller.dart';
import 'package:ai_voice_app/services/generations_controller.dart';
import 'package:ai_voice_app/providers/providers.dart';
import 'package:ai_voice_app/styles.dart';
import 'package:ai_voice_app/widgets/appBarBackButton.dart';
import 'package:ai_voice_app/widgets/generalCustomButton.dart';
import 'package:ai_voice_app/widgets/generalIconContainer.dart';
import 'package:ai_voice_app/widgets/inputField.dart';
import 'package:ai_voice_app/widgets/playButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class TextToSpeech extends StatefulWidget {
  const TextToSpeech({super.key});

  @override
  State<TextToSpeech> createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech> {
  final AudioPlayer audioPlayer = AudioPlayer();
  TextEditingController contentFieldController = TextEditingController();
  int? countervall = 0;
  TextEditingController generationNameController = TextEditingController();
  bool onProcces = false;
  String? selectedAiVoice;

  Consumer generateVoiceButton() {
    return Consumer(
      builder: (context, ref, child) {
        String? userid = ref.read(useridProvider);
        int tokenBalance = ref.watch(tokenAmountAsyncProvider).value!;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            //padding: EdgeInsets.symmetric(vertical: 10),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Styles.buttonColor,
                disabledBackgroundColor: Styles.iconButtonBgColor,
              ),
              onPressed: (selectedAiVoice == null)
                  ? null
                  : () async {
                      int tokenCost = contentFieldController.text.length;
                      if (selectedAiVoice != null &&
                          tokenCost <= tokenBalance) {
                        setState(() {
                          onProcces = true;
                        });
                        //104

                        await GenerationController().loadAndPlaySpeech(
                            context,
                            contentFieldController.text,
                            selectedAiVoice!.toLowerCase(),
                            audioPlayer,
                            generationNameController.text,
                            userid!);
                        await ref
                            .read(tokenAmountAsyncProvider.notifier)
                            .decreaseTokenAmount(tokenCost);
                        setState(() {
                          onProcces = false;
                        });
                      }
                    },
              child: onProcces
                  ? const CircularProgressIndicator()
                  : Text(
                      'Generate',
                      style: Styles.normalTextStyle.copyWith(fontSize: 25),
                    ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.scaffoldBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Styles.scaffoldBackground,
        leading: AppBarBackButton(),
        title: const Text(
          "Text To Speech",
          style: Styles.normalTextStyle,
        ),
        centerTitle: true,
        actions: [
          IconContainer(
            icon: Icons.text_snippet_rounded,
            color: Styles.iconButtonBgColor,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllVoiceGenerations()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Styles.smallSpacer,
              TtsInputField(contentFieldController: contentFieldController),
              Styles.smallSpacer,
              SmallInputField(
                  hintText: "Generation Name",
                  inputController: generationNameController),
              Styles.smallSpacer,
              Consumer(
                builder: (context, ref, child) {
                  final aiVoiceNames = ref.watch(aiVoicesProvider);
                  return DropdownButton(
                    dropdownColor: Styles.containerBgColor,
                    iconEnabledColor: Styles.textAndIconColorWhite,
                    iconSize: 40,

                    // elevation: 0,
                    borderRadius: BorderRadius.circular(10),
                    hint: Text(
                      selectedAiVoice ?? "Select Voice",
                      style: Styles.normalTextStyle,
                    ),
                    style: Styles.normalTextStyle,
                    items: aiVoiceNames.map((String voice) {
                      return DropdownMenuItem<String>(
                        value: voice[0].toUpperCase() +
                            voice.substring(1).toLowerCase(),
                        child: Text(
                          voice[0].toUpperCase() +
                              voice.substring(1).toLowerCase(),
                          style: Styles.normalTextStyle,
                        ),
                      );
                    }).toList(),
                    onChanged: (selectedValue) {
                      setState(() {
                        selectedAiVoice = selectedValue;
                      });
                    },
                  );
                },
              ),
              generateVoiceButton(),
              Styles.smallSpacer,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PauseButton(
                    audioPlayer: audioPlayer,
                    onPressed: () async {
                      await audioPlayer.pause();
                    },
                  ),
                  PlayButton(
                    audioPlayer: audioPlayer,
                    onPressed: () async {
                      await AudioController().playAudio(audioPlayer);
                    },
                  ),
                ],
              ),
              Styles.smallSpacer
            ],
          ),
        ),
      ),
    );
  }
}

class TtsInputField extends StatelessWidget {
  const TtsInputField({
    super.key,
    required this.contentFieldController,
  });

  final TextEditingController contentFieldController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 51, 51, 54),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          border: Border.all(color: Colors.black)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextFormField(
          controller: contentFieldController,
          style: Styles.normalTextStyle,
          buildCounter: (context,
              {currentLength = 0, isFocused = true, maxLength}) {
            return Text(
              "$currentLength",
              style: Styles.normalTextStyle,
            );
          },
          decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Text To Generate',
              hintStyle: Styles.normalTextStyle),
          cursorColor: Colors.orange,
          maxLines: null,
        ),
      ),
    );
  }
}
