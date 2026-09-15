import 'package:shared_preferences/shared_preferences.dart';

import 'app_keys.dart';

class MySharedPreferences {
  MySharedPreferences._();

  static MySharedPreferences instance = MySharedPreferences._();
  late SharedPreferences preferences;

  Future<void> initPref() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<void> saveProfile(bool value) async {
    await preferences.setBool(AppKeys.hasProfile, value);
  }

  Future<bool> get hasProfile async =>
      preferences.getBool(AppKeys.hasProfile) ?? false;
  Future<void> paymentActive(bool value) async {
    await preferences.setBool(AppKeys.paymentActive, value);
  }

  Future<bool> get paymentOk async =>
      preferences.getBool(AppKeys.paymentActive) ?? false;

  Future<void> saveUser(String value) async {
    await preferences.setString(AppKeys.user, value);
  }

  Future<String?> get user async => preferences.getString(AppKeys.user);

  Future<void> payment(String value) async {
    await preferences.setString(AppKeys.payment, value);
  }

  Future<String?> get paymentData async => preferences.getString(AppKeys.payment);
}
