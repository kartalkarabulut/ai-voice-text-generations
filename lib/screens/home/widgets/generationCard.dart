import 'package:ai_voice_app/screens/generation-pages/textToSpeech/textToSpeech.dart';
import 'package:ai_voice_app/screens/home/home_screen.dart';
import 'package:ai_voice_app/styles.dart';
import 'package:ai_voice_app/widgets/generalIconContainer.dart';
import 'package:flutter/material.dart';

class GenerationCard extends StatelessWidget {
  GenerationCard(
      {super.key,
      required this.title,
      required this.headerIcon,
      required this.onTap});
  String title;
  IconData headerIcon;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: screenHeight * 0.25,
        width: screenWidth * 0.9,
        decoration: const BoxDecoration(
          color: Styles.iconButtonBgColor,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconContainer(
              icon: headerIcon,
              color: Styles.scaffoldBackground,
            ),
            Text(
              title,
              style: Styles.normalTextStyle,
            ),
            Row(
              children: [
                Container(
                  //margin: EdgeInsets.symmetric(horizontal: 40),
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.08,
                  decoration: const BoxDecoration(
                      color: Styles.scaffoldBackground,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Generate New",
                        style: Styles.normalTextStyle,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                IconContainer(
                  icon: Icons.navigate_next_rounded,
                  color: Styles.scaffoldBackground,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
