import 'package:ai_voice_app/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarBackButton extends StatelessWidget {
  AppBarBackButton({super.key});
  AppBarBackButton.black({super.key})
      : color = Colors.white,
        icon = Icons.cancel_outlined;
  Color? color;
  IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          icon ?? Icons.arrow_back_ios_new_rounded,
          color: color ?? Styles.textAndIconColorWhite,
          size: 30,
        ),
      ),
    );
  }
}
