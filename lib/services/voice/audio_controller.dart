import 'package:just_audio/just_audio.dart';

class AudioController {
  Future playAudio(AudioPlayer audioPlayer) async {
    await audioPlayer.seek(Duration.zero);
    await audioPlayer.play();
  }

  Future pauseAudio(AudioPlayer audioPlayer) async {
    await audioPlayer.pause();
  }
}
