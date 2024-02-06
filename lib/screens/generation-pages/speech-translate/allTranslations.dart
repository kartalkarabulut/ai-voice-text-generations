import 'package:ai_voice_app/models/audio-voice/transcriptedTextModel.dart';
import 'package:ai_voice_app/models/audio-voice/translatedtext.dart';
import 'package:ai_voice_app/providers/providers.dart';
import 'package:ai_voice_app/styles.dart';
import 'package:ai_voice_app/widgets/appBarBackButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllTranslations extends ConsumerWidget {
  const AllTranslations({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue translatedTextAsyncValue = ref.watch(translatedTextProvider);
    return Scaffold(
      appBar: AppBar(
          leading: AppBarBackButton(),
          centerTitle: true,
          title: const Text(
            "All Translations",
            style: Styles.normalTextStyle,
          )),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(translatedTextProvider.future),
        child: Center(
          child: Column(
            children: [
              Styles.smallSpacer,
              PullToRefreshButton(ref: ref, provider: translatedTextProvider),
              Styles.smallSpacer,
              Expanded(
                child: translatedTextAsyncValue.when(
                  data: (data) {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        TranslatedText translatedText = data[index];
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Styles.containerBgColor,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(20),
                            leadingAndTrailingTextStyle: Styles.normalTextStyle,
                            style: ListTileStyle.drawer,
                            title: Text(
                              translatedText.translatedText,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.normalTextStyle,
                            ),
                            subtitle: Text(
                              "Name: ${translatedText.translationName}",
                              style: Styles.normalTextStyle,
                            ),
                            trailing: Text(
                                "${translatedText.translationTime.day}/${translatedText.translationTime.month}/${translatedText.translationTime.year}"),
                          ),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) {
                    return Text("Veri çekme hatası: $error");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PullToRefreshButton extends StatelessWidget {
  const PullToRefreshButton({
    super.key,
    required this.ref,
    required this.provider,
  });

  final FutureProvider provider;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ref.refresh(provider.future),
      child: Container(
          height: 30,
          width: 120,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // gölge rengi ve opaklığı
                offset: Offset(0, 2), // x, y ofset değerleri
                blurRadius: 4, // gölge bulanıklığı
                spreadRadius: 1, // gölge yayılma alanı
              ),
            ],
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
              child: Text(
            "Refresh",
            style: Styles.normalTextStyle,
          ))),
    );
  }
}
