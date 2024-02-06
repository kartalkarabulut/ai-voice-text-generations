import 'package:ai_voice_app/styles.dart';
import 'package:ai_voice_app/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeneralButton extends ConsumerWidget {
  GeneralButton(
      {super.key,
      this.onPressed,
      required this.buttonText,
      this.icon,
      this.isBlack});
  GeneralButton.amber(
      {super.key,
      this.onPressed,
      required this.buttonText,
      this.icon,
      this.isBlack})
      : color = Colors.amber[400];

  VoidCallback? onPressed;
  String buttonText;
  IconData? icon;
  Color? color;
  bool? isBlack;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.1,
      width: screenWidth * 0.8,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: color ?? Styles.buttonColor),
          onPressed: onPressed,
          child: icon != null
              ? Icon(icon)
              : (isBlack != null)
                  ? AppText.normalBlackBold(text: buttonText)
                  : AppText.normalWhite(text: buttonText)),
    );
  }
}
