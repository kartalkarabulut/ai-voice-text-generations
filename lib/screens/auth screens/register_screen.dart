import 'package:ai_voice_app/screens/auth%20screens/customTextField.dart';
import 'package:ai_voice_app/screens/home/home_screen.dart';
import 'package:ai_voice_app/services/auth/auth_services.dart';
import 'package:ai_voice_app/styles.dart';
import 'package:ai_voice_app/widgets/appBarBackButton.dart';
import 'package:ai_voice_app/widgets/generalCustomButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: AppBarBackButton(),
        title: Text(
          "Sign Up",
          style: Styles.normalTextStyle.copyWith(fontSize: 25),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AuthField(
                  controller: fullNameController,
                  hintText: "Full Name",
                  icon: CupertinoIcons.mail,
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  }),
              Styles.smallSpacer,
              AuthField(
                controller: emailController,
                inputType: TextInputType.emailAddress,
                hintText: "Email",
                icon: CupertinoIcons.mail_solid,
              ),
              Styles.smallSpacer,
              AuthField(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
                icon: CupertinoIcons.lock_shield,
              ),
              Styles.mediumSpacer,
              GeneralButton(
                buttonText: "Sign Up",
                onPressed: () async {
                  var navigator = Navigator.of(context);
                  await AuthenticationServices().registerWithMailPassword(
                      fullNameController.text,
                      emailController.text,
                      passwordController.text,
                      context);

                  navigator.pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
