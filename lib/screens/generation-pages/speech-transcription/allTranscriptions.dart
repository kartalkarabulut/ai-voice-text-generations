import 'package:ai_voice_app/models/audio-voice/transcriptedTextModel.dart';
import 'package:ai_voice_app/providers/providers.dart';
import 'package:ai_voice_app/screens/generation-pages/speech-translate/allTranslations.dart';
import 'package:ai_voice_app/styles.dart';
import 'package:ai_voice_app/widgets/appBarBackButton.dart';
import 'package:ai_voice_app/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllTranscriptions extends ConsumerWidget {
  const AllTranscriptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue transcriptedTextsAsyncValue =
        ref.watch(transcriptedTextProvider);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "All Transcriptions",
            style: Styles.normalTextStyle,
          ),
          leading: AppBarBackButton(),
        ),
        body: RefreshIndicator(
          onRefresh: () => ref.refresh(transcriptedTextProvider.future),
          child: Center(
            child: Column(
              children: [
                PullToRefreshButton(
                    ref: ref, provider: transcriptedTextProvider),
                Styles.smallSpacer,
                Expanded(
                  child: transcriptedTextsAsyncValue.when(
                    data: (data) {
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          TranscriptedText transcriptedText = data[index];
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration:
                                BoxDecoration(color: Styles.containerBgColor),
                            child: ListTile(
                              leadingAndTrailingTextStyle:
                                  Styles.normalTextStyle,
                              style: ListTileStyle.drawer,
                              contentPadding: EdgeInsets.all(20),
                              title: Text(
                                transcriptedText.transcriptedText,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.normalTextStyle,
                              ),
                              subtitle: Text(
                                transcriptedText.transcriptionName,
                                style: Styles.normalTextStyle,
                              ),
                              trailing: AppText.normalWhite(
                                text:
                                    '${transcriptedText.transcriptionTime.day}/${transcriptedText.transcriptionTime.month}/${transcriptedText.transcriptionTime.year}',
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) {
                      return Text("Data Error: $error");
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
