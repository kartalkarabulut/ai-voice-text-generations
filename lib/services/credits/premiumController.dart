import 'package:ai_voice_app/models/auth-register-login/user_model.dart';
import 'package:ai_voice_app/services/auth/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PremiumController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  ///100k token => 500dk or 100k char
  ///50k token => 250dk or 50k char
  ///1 char => 1 token
  ///1 sn = 3.35 token
  Future smallPurchase(String userId) async {
    try {
      var userCollection = firebaseFirestore.collection("users");
      var userDocument = await userCollection.doc(userId).get();
      if (userDocument.exists) {
        UserModel user =
            UserModel.fromJson(userDocument.data() as Map<String, dynamic>);
        int tokenAmount = user.tokenAmount;
        print("işlemlerden önce amount = ${user.tokenAmount}");
        await userCollection.doc(userId).update({
          "tokenAmount": tokenAmount + 50000,
        });
        print("firebase işlemlerden sonra amount = ${user.tokenAmount}");
        user.tokenAmount += 50000;
        print(
            "firebaseden sonra local güncellemeden sonra işlemlerden önce amount = ${user.tokenAmount}");
      }
    } catch (e) {
      print("hatamizzz::: $e");
    }
  }

  Future decreaseTokenAmountOfUser(String userId, int amount) async {
    try {
      var userCollection = firebaseFirestore.collection("users");
      var userDocument = await userCollection.doc(userId).get();
      if (userDocument.exists) {
        UserModel user =
            UserModel.fromJson(userDocument.data() as Map<String, dynamic>);
        int tokenAmount = user.tokenAmount;
        userCollection.doc(userId).update({
          "tokenAmount": tokenAmount - amount,
        });
      }
    } catch (e) {
      print("hataaa::: $e");
    }
  }

  Future bigPurchase(String userId) async {
    try {
      var userCollection = firebaseFirestore.collection("users");
      var userDocument = await userCollection.doc(userId).get();
      if (userDocument.exists) {
        UserModel user =
            UserModel.fromJson(userDocument.data() as Map<String, dynamic>);
        int tokenAmount = user.tokenAmount;
        print("işlemlerden önce amount = ${user.tokenAmount}");
        await userCollection.doc(userId).update({
          "tokenAmount": tokenAmount + 100000,
        });
        print("firebase işlemlerden sonra amount = ${user.tokenAmount}");
        user.tokenAmount += 100000;
        print(
            "firebaseden sonra local güncellemeden sonra işlemlerden önce amount = ${user.tokenAmount}");
      }
    } catch (e) {
      print("hatamizzz::: $e");
    }
  }

  Future<int> getTokenAmountOfUser(String userId) async {
    try {
      var userCollection = firebaseFirestore.collection("users");
      var userDocument = await userCollection.doc(userId).get();

      int tokenamount = userDocument.data()!["tokenAmount"];
      print("Token miktarı =$tokenamount ");

      return tokenamount;
    } catch (e) {
      print("hataaa::: $e");
      throw e;
    }
  }

  Future<bool> subscribeToPremium(String userId, BuildContext context) async {
    try {
      var userCollection = firebaseFirestore.collection("users");
      var userDocument = await userCollection.doc(userId).get();

      if (userDocument.exists) {
        await userCollection.doc(userId).update({
          "userType": UserType.premium.toString(),
        });
        print("updated");
        return true;
      }
      return false;
    } catch (e) {
      showSnackBar(context, "Failed To Subscribe Premium");
      return false;
    }
  }

  Future<bool> cancelToPremium(String userId, BuildContext context) async {
    try {
      var userCollection = firebaseFirestore.collection("users");
      var userDocument = await userCollection.doc(userId).get();

      if (userDocument.exists) {
        await userCollection.doc(userId).update({
          "userType": UserType.normal.toString(),
        });
        print("updated");
        return true;
      }
      return false;
    } catch (e) {
      showSnackBar(context, "Failed To Subscribe Premium");
      return false;
    }
  }
}
