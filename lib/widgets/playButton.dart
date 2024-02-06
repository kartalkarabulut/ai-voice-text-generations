import 'package:ai_voice_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayButton extends StatelessWidget {
  PlayButton({super.key, required this.audioPlayer, this.onPressed});

  final AudioPlayer audioPlayer;
  VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Styles.buttonColor),
      onPressed: onPressed,
      child: const Icon(
        Icons.play_arrow,
        color: Styles.textAndIconColorWhite,
      ),
    );
  }
}

class PauseButton extends StatelessWidget {
  PauseButton({super.key, required this.audioPlayer, this.onPressed});

  final AudioPlayer audioPlayer;
  VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Styles.buttonColor),
      onPressed: onPressed,
      child: const Icon(
        Icons.pause,
        color: Styles.textAndIconColorWhite,
      ),
    );
  }
}
