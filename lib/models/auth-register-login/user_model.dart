import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';

class UserModel {
  UserModel({
    required this.fullName,
    required this.userid,
    required this.userType,
    required this.registrationTime,
    this.tokenAmount = 10000,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
        fullName: map['fullName'],
        userid: map["userid"],
        userType: parseUserType(map['userType']),
        registrationTime: (map['registrationTime'] as Timestamp).toDate(),
        tokenAmount: map["tokenAmount"]);
  }

  String fullName;
  DateTime registrationTime;
  int tokenAmount;
  UserType userType;
  String userid;

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "userid": userid,
      "userType": userType.toString(),
      "registrationTime": Timestamp.fromDate(registrationTime),
      "tokenAmount": tokenAmount
    };
  }

  static UserType parseUserType(String userTypeString) {
    if (userTypeString == 'UserType.normal') {
      return UserType.normal;
    } else if (userTypeString == 'UserType.premium') {
      return UserType.premium;
    }
    return UserType.normal;
  }
}

enum UserType {
  normal,
  premium,
}

class UserPurchaseController {
  UserModel user;
  List purchaseHistry;

  UserPurchaseController({required this.user, required this.purchaseHistry});
}
