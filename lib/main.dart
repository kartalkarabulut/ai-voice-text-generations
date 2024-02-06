import 'package:ai_voice_app/firebase_options.dart';
import 'package:ai_voice_app/models/connection/connectivity_controller.dart';
import 'package:ai_voice_app/providers/providers.dart';
import 'package:ai_voice_app/screens/auth%20screens/login/login_screen.dart';
import 'package:ai_voice_app/screens/home/home_screen.dart';
import 'package:ai_voice_app/styles.dart';
import 'package:ai_voice_app/widgets/appBarBackButton.dart';
import 'package:ai_voice_app/widgets/texts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui' as ui;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const ProviderScope(
      child: AiApp(),
    ),
  );
}

class AiApp extends StatelessWidget {
  const AiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      textDirection: ui.TextDirection.ltr,
      children: [
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            //primaryColor: Colors.white,
            scaffoldBackgroundColor: Styles.scaffoldBackground,
            appBarTheme:
                AppBarTheme(backgroundColor: Styles.scaffoldBackground),
            iconTheme: IconThemeData(color: Styles.textAndIconColorWhite),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Styles.buttonColor,
                textStyle: Styles.normalTextStyle,
              ),
            ),
          ),
          home: const AuthWidget(),
        ),
        const ConnectionAlert(),
      ],
    );
  }
}

class ConnectionAlert extends StatefulWidget {
  const ConnectionAlert({super.key});

  @override
  State<ConnectionAlert> createState() => _ConnectionAlertState();
}

class _ConnectionAlertState extends State<ConnectionAlert> {
  ConnectivityController connectivityController = ConnectivityController();

  @override
  void initState() {
    connectivityController.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: connectivityController.isConnected,
      builder: (context, value, child) {
        if (value) {
          return const SizedBox();
        } else {
          return Center(
            child: Container(
              color: Colors.red,
              child: const Center(
                child: Text(
                  "No internet connection",
                  textDirection: TextDirection.ltr,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class AuthWidget extends ConsumerWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        } else {
          return const HomeScreen();
        }
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      error: (error, stack) {
        return Text('Hata: $error');
      },
    );
  }
}
