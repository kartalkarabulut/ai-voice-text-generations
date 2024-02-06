import 'package:ai_voice_app/providers/providers.dart';
import 'package:ai_voice_app/services/credits/premiumController.dart';
import 'package:ai_voice_app/styles.dart';
import 'package:ai_voice_app/widgets/appBarBackButton.dart';
import 'package:ai_voice_app/widgets/generalCustomButton.dart';
import 'package:ai_voice_app/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PremiumOfferScreen extends StatefulWidget {
  const PremiumOfferScreen({super.key});

  @override
  State<PremiumOfferScreen> createState() => _PremiumOfferScreenState();
}

class _PremiumOfferScreenState extends State<PremiumOfferScreen> {
  bool isSmallPurchase = false;
  bool isBigPurchase = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  //padding: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/woman.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 10,
                  child: AppBarBackButton.black(),
                ),
                Positioned(
                  bottom: 10,
                  child: Text(
                    "Join PRO",
                    style: Styles.normalTextStyle
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
              ],
            ),
            Styles.mediumSpacer,
            GestureDetector(
              onTap: () {
                setState(() {
                  if (isSmallPurchase == true) {
                    isSmallPurchase = false;
                  }
                  isBigPurchase = !isBigPurchase;
                });
              },
              child: YearlySubscriptionContainer(isBigPurchase: isBigPurchase),
            ),
            Styles.smallSpacer,
            GestureDetector(
              onTap: () {
                setState(() {
                  if (isBigPurchase == true) {
                    isBigPurchase = false;
                  }
                  isSmallPurchase = !isSmallPurchase;
                });
              },
              child: MonthlySubscriptionContainer(
                isSmallPurchase: isSmallPurchase,
              ),
            ),
            Styles.mediumSpacer,
            Consumer(
              builder: (context, ref, child) {
                String? userId = ref.watch(useridProvider);
                return GeneralButton.amber(
                  isBlack: true,
                  buttonText: "Subscribe",
                  onPressed: () async {
                    if (isBigPurchase) {}
                    bool isSubscribed = await PremiumController()
                        .subscribeToPremium(userId!, context);
                    if (isSubscribed) {
                      // ref.read(userTypeProvider.notifier).state =
                      //     UserType.premium;
                    }
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class MonthlySubscriptionContainer extends StatelessWidget {
  MonthlySubscriptionContainer({super.key, required this.isSmallPurchase});

  bool isSmallPurchase;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: isSmallPurchase ? Colors.amberAccent : null,
        border: Border.all(
            color: isSmallPurchase ? Colors.red : Colors.orange,
            width: isSmallPurchase ? 4 : 1),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isSmallPurchase
                    ? AppText.normalBlackBold(text: "Small Purchase")
                    : AppText.normalWhite(text: "Small Purchase"),
                isSmallPurchase
                    ? AppText.normalBlackBold(text: "4\$ / 50k Tokens")
                    : AppText.normalWhite(text: "4\$ / 50k Tokens")
              ],
            ),
          ),
          // const SizedBox(
          //   width: 40,
          // ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                const VerticalDivider(thickness: 0.3),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.info_outline_rounded,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class YearlySubscriptionContainer extends StatelessWidget {
  const YearlySubscriptionContainer({
    super.key,
    required this.isBigPurchase,
  });

  final bool isBigPurchase;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: isBigPurchase ? Colors.amberAccent : null,
        border: Border.all(
            color: isBigPurchase ? Colors.red : Colors.orange,
            width: isBigPurchase ? 4 : 1),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isBigPurchase
                    ? AppText.normalBlackBold(text: "Big Purchase")
                    : AppText.normalWhite(text: "Big Purchase"),
                isBigPurchase
                    ? AppText.normalBlackBold(
                        text: "6\$ / 100k Tokens",
                      )
                    : AppText.normalWhite(
                        text: "6\$ / 100k Tokens",
                      )
              ],
            ),
          ),
          // const SizedBox(
          //   width: 40,
          // ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                const VerticalDivider(thickness: 0.3),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.info_outline_rounded,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// Positioned(
//           right: 20,
//           top: MediaQuery.of(context).size.height * -0.030,
//           child: Container(
//             height: MediaQuery.of(context).size.height * 0.070,
//             width: MediaQuery.of(context).size.width * 0.25,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.amber[400],
//                 border: Border.all(
//                     width: isYearSelected ? 3 : 1,
//                     color: isYearSelected ? Colors.red : Colors.black)),
//             child: Center(child: AppText.normalBlackBold(text: "Save %50")),
//           ),
//         )