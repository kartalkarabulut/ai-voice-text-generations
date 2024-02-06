import 'package:ai_voice_app/styles.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  AppText.normalBlack({required this.text, this.fontWeight})
      : fontSize = 20,
        textColor = Colors.black;

  AppText.normalBlackBold({
    required this.text,
  })  : fontSize = 20,
        textColor = Colors.black,
        fontWeight = FontWeight.bold;

  AppText.normalWhite({required this.text, this.fontWeight})
      : fontSize = 20,
        textColor = Colors.white;
  AppText.normalWhiteSmall({required this.text, this.fontWeight})
      : fontSize = 18,
        textColor = Colors.white;

  final double fontSize;
  final FontWeight? fontWeight;
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
