import 'dart:async';

import 'package:ai_voice_app/providers/providers.dart';
import 'package:ai_voice_app/services/credits/premiumController.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenAmountAsyncValueNotifier extends AsyncNotifier<int> {
  PremiumController premiumController = PremiumController();

  @override
  Future<int> build() async {
    String? userId = ref.read(useridProvider);
    return premiumController.getTokenAmountOfUser(userId!);
  }

  Future<void> decreaseTokenAmount(int amount) async {
    String? userId = ref.read(useridProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await premiumController.decreaseTokenAmountOfUser(userId!, amount);
      return premiumController.getTokenAmountOfUser(userId);
    });
  }

  //50k token
  Future<void> doSmallPurchase() async {
    String? userId = ref.read(useridProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await premiumController.smallPurchase(userId!);
      return premiumController.getTokenAmountOfUser(userId);
    });
  }

  //100k token
  Future<void> doBigPurchase() async {
    String? userId = ref.read(useridProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await premiumController.bigPurchase(userId!);
      return premiumController.getTokenAmountOfUser(userId);
    });
  }
}

final tokenAmountAsyncProvider =
    AsyncNotifierProvider<TokenAmountAsyncValueNotifier, int>(
  () {
    return TokenAmountAsyncValueNotifier();
  },
);
