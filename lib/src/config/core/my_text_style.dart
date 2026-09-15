import 'package:flutter/material.dart';

sealed class MyTextStyle {
  const MyTextStyle._();

  static TextStyle w700 = const TextStyle(
      fontFamily: 'unbounded', fontWeight: FontWeight.w700);

  static TextStyle w600 =
      const TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w600);

  static TextStyle w400 =
      const TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w400);
}
