import 'package:ai_voice_app/screens/auth%20screens/register_screen.dart';
import 'package:ai_voice_app/styles.dart';
import 'package:ai_voice_app/widgets/texts.dart';
import 'package:flutter/material.dart';

class NavigateToSignupPage extends StatelessWidget {
  const NavigateToSignupPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Divider(
          color: Styles.iconButtonBgColor,
          thickness: 2,
        ),
        TextButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterPage(),
              ),
            );
          },
          child: AppText.normalWhite(
            text: "Sign Up",
          ),
        ),
      ],
    );
  }
}
