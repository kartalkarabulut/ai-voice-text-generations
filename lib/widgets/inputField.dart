import 'package:ai_voice_app/styles.dart';
import 'package:flutter/material.dart';

class SmallInputField extends StatelessWidget {
  SmallInputField(
      {super.key, required this.inputController, required this.hintText});

  String hintText;

  final TextEditingController inputController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 51, 51, 54),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          border: Border.all(color: Colors.black)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: TextFormField(
          controller: inputController,
          style: Styles.normalTextStyle,
          buildCounter: (context,
              {currentLength = 0, isFocused = true, maxLength}) {
            return Text(
              "$currentLength",
              style: Styles.normalTextStyle,
            );
          },
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: Styles.normalTextStyle),
          cursorColor: Colors.orange,
          maxLines: 1,
          maxLength: 30,
        ),
      ),
    );
  }
}
