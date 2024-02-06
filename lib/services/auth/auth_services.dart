import 'package:ai_voice_app/models/auth-register-login/user_model.dart';
import 'package:ai_voice_app/services/db-services-firebase/firestore_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future registerWithMailPassword(
    String fullName,
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      String userid = userCredential.user!.uid;
      FirestoreDb().saveUserData(
        UserModel(
          fullName: fullName,
          userid: userid,
          userType: UserType.normal,
          registrationTime: DateTime.now(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Registration failed";

      if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
          content: Text(errorMessage),
        ),
      );
    }
  }

  Future<bool> loginWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (error) {
      showSnackBar(context, "${error.message}");
      return false;
    }
  }
}

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.orange,
      duration: const Duration(seconds: 3),
      content: Text(text),
    ),
  );
}
