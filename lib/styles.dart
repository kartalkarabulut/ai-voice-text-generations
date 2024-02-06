import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Styles {
  static const TextStyle productListTitle = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
  );
  static const TextStyle productRowItemName = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle productRowItemPrice = TextStyle(
    color: Color(0xFF8E8E93),
    fontSize: 13,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle normalTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 20,
  );

  static const TextStyle productPageItemPrice = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const Color iconButtonBgColor = Color(0xFF26272C);
  static const Color containerBgColor = Color(0xFF111317);
  static const Color scaffoldBackground = Color(0xFF0D0F13);

  static const Color buttonColor = Color(0xFF0F77F0);

  static const Color textAndIconColorWhite = Color(0xffffffff);

  static const Widget mediumSpacer = SizedBox(height: 50);
  static const Widget smallSpacer = SizedBox(height: 20);

  static const Widget largeSpacer = SizedBox(height: 100);
}
