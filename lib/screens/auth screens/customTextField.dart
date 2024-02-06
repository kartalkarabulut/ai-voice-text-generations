import 'package:ai_voice_app/styles.dart';
import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  AuthField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.icon,
      this.obscureText,
      this.onEditingComplete,
      this.inputType});

  final TextEditingController controller;
  String hintText;
  IconData icon;
  bool? obscureText;
  VoidCallback? onEditingComplete;
  TextInputType? inputType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Styles.iconButtonBgColor,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: TextField(
        controller: controller,
        style: Styles.normalTextStyle,
        textInputAction: TextInputAction.next,
        keyboardType: inputType ?? TextInputType.text,
        onEditingComplete: onEditingComplete,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Styles.normalTextStyle.copyWith(fontSize: 15),
          border: InputBorder.none,
          prefixIcon: Icon(
            icon,
            color: Styles.textAndIconColorWhite,
          ),
        ),
        obscureText: obscureText ?? false,
      ),
    );
  }
}
