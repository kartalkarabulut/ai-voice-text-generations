import 'package:ai_voice_app/providers/providers.dart';
import 'package:ai_voice_app/screens/premium/premiumOfferScreen.dart';
import 'package:ai_voice_app/styles.dart';
import 'package:ai_voice_app/widgets/appBarBackButton.dart';
import 'package:ai_voice_app/widgets/generalCustomButton.dart';
import 'package:ai_voice_app/widgets/generalIconContainer.dart';
import 'package:ai_voice_app/widgets/texts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userInfoProvider);
    return Scaffold(
      appBar: AppBar(
        leading: AppBarBackButton(),
        centerTitle: true,
        title: AppText.normalWhite(text: "text"),
        actions: [
          IconContainer(
            icon: Icons.logout,
            color: Styles.buttonColor,
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Styles.mediumSpacer,
            const SizedBox(
              height: 100,
              width: 100,
              child: CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: 100,
                ),
              ),
            ),
            Styles.smallSpacer,
            userData.when(
              data: (data) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppText.normalWhite(text: data.fullName),
                    Styles.smallSpacer,
                    AppText.normalWhite(text: "User ID:"),
                    AppText.normalWhite(text: data.userid),
                    Styles.smallSpacer,
                    AppText.normalWhite(
                        text: "Token Balane : ${data.tokenAmount.toString()}")
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) {
                return Text("Veri çekme hatası: $error");
              },
            ),
            Styles.smallSpacer,
            GeneralButton(
              buttonText: "Buy Token",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PremiumOfferScreen()));
              },
            ),
            Styles.smallSpacer,
          ],
        ),
      ),
    );
  }
}
