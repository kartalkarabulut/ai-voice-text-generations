import 'package:ai_voice_app/models/audio-voice/voice_model.dart';
import 'package:ai_voice_app/providers/providers.dart';
import 'package:ai_voice_app/screens/generation-pages/speech-translate/allTranslations.dart';
import 'package:ai_voice_app/styles.dart';
import 'package:ai_voice_app/widgets/appBarBackButton.dart';
import 'package:ai_voice_app/widgets/playButton.dart';
import 'package:ai_voice_app/widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class AllVoiceGenerations extends ConsumerWidget {
  const AllVoiceGenerations({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue speechAsyncValue = ref.watch(generatedSpeechProvider);
    AudioPlayer audioPlayer = AudioPlayer();
    return Scaffold(
      appBar: AppBar(
        leading: AppBarBackButton(),
        centerTitle: true,
        title: AppText.normalWhite(
          text: "All Voice Generations",
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(generatedSpeechProvider.future),
        child: Center(
          child: Column(
            children: [
              PullToRefreshButton(ref: ref, provider: generatedSpeechProvider),
              Styles.smallSpacer,
              Expanded(
                child: speechAsyncValue.when(
                  data: (data) {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        GeneratedSpech generatedSpech = data[index];
                        return Container(
                          margin: EdgeInsets.all(10),
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Styles.containerBgColor,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(20),
                            title: AppText.normalWhite(
                                text: generatedSpech.generationName),
                            subtitle: AppText.normalWhite(
                              text:
                                  'Generated on: ${generatedSpech.generationTime.day}/${generatedSpech.generationTime.month}/${generatedSpech.generationTime.year}',
                            ),
                            trailing: PlayButton(
                              audioPlayer: audioPlayer,
                              onPressed: () async {
                                audioPlayer.setAudioSource(AudioSource.uri(
                                    Uri.parse(generatedSpech.storageUrl)));
                                await audioPlayer.play();
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                      child: CupertinoActivityIndicator(
                    animating: true,
                  )),
                  error: (error, stackTrace) => Text('Error: $error'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
