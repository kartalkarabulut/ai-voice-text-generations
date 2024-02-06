import 'package:ai_voice_app/screens/auth%20screens/customTextField.dart';
import 'package:ai_voice_app/screens/auth%20screens/login/widgets/navigateToSignUpPageButton.dart';
import 'package:ai_voice_app/screens/home/home_screen.dart';
import 'package:ai_voice_app/services/auth/auth_services.dart';
import 'package:ai_voice_app/styles.dart';
import 'package:ai_voice_app/widgets/generalCustomButton.dart';
import 'package:ai_voice_app/widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Sign In",
          style: Styles.normalTextStyle.copyWith(fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Styles.largeSpacer,
            AppText.normalWhite(text: "Enter Your Email & Password"),
            Styles.smallSpacer,
            AuthField(
                inputType: TextInputType.emailAddress,
                controller: emailController,
                hintText: "Email",
                icon: CupertinoIcons.mail,
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                }),
            SizedBox(height: 16.0),
            AuthField(
              obscureText: true,
              controller: passwordController,
              hintText: "Password",
              icon: CupertinoIcons.lock_shield,
            ),
            Styles.smallSpacer,
            GestureDetector(
              onTap: () {},
              child: Text(
                "Forgot Password?",
                textAlign: TextAlign.end,
                style: Styles.normalTextStyle.copyWith(fontSize: 15),
              ),
            ),
            Styles.mediumSpacer,
            GeneralButton(
              buttonText: "Sign In",
              onPressed: () async {
                var navigator = Navigator.of(context);
                if (emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  bool isSigninSuccesful = await AuthenticationServices()
                      .loginWithEmailPassword(emailController.text,
                          passwordController.text, context);
                  if (isSigninSuccesful) {
                    navigator.pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  }
                }
              },
            ),
            Styles.mediumSpacer,
            const NavigateToSignupPage(),
          ],
        )),
      ),
    );
  }
}
