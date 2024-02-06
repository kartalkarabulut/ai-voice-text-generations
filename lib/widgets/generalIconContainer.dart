import 'package:ai_voice_app/styles.dart';
import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  IconContainer(
      {super.key, required this.icon, required this.color, this.onPressed});

  Color color;
  IconData icon;
  VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: Styles.textAndIconColorWhite,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
