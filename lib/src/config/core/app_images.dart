import 'dart:math';

sealed class AppImages{
  AppImages._();
  static const String female_1 = 'assets/images/female-1.jpeg';
  static const String female_2 = 'assets/images/female-2.jpg';
  static const String female_3 = 'assets/images/female-3.webp';
  static const String female_4 = 'assets/images/female-4.jpeg';
  static const String female_5 = 'assets/images/female-5.jpg';
  static const String male_1 = 'assets/images/male-1.jpg';
  static const String male_2 = 'assets/images/male-2.jpg';
  static const String male_3 = 'assets/images/male-3.jpg';
  static const String male_4 = 'assets/images/male-4.jpg';
  static const String male_5 = 'assets/images/male-5.webp';
  static const String logo = 'assets/images/img_logo.png';
  static const String send = 'assets/images/img_send.png';
  static const String payme = 'assets/images/pay_me.png';
  static const String google = 'assets/images/google.png';
  static const String home1 = 'assets/images/home1.png';

}
String getFemaleRandomImages() {
  List<String> list = [
    AppImages.female_1,
    AppImages.female_2,
    AppImages.female_3,
    AppImages.female_4,
    AppImages.female_5,
  ];
  final random = Random();
  return list[random.nextInt(list.length)];
}

String getMaleRandomImages() {
  List<String> list = [
    AppImages.male_1,
    AppImages.male_2,
    AppImages.male_3,
    AppImages.male_4,
    AppImages.male_5,
  ];
  final random = Random();
  return list[random.nextInt(list.length)];
}