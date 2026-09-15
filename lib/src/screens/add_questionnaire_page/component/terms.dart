import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sovchilar/src/config/core/app_colors.dart';
import 'package:sovchilar/src/screens/questionnaire_page/component/app_button.dart';
import 'package:sovchilar/translations/locale_keys.g.dart';

Future<void> showTermsDialog(BuildContext context,{required VoidCallback onPressed}) async {

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              context.locale == const Locale('uz')
                  ? "Qoidalar va Shartlar"
                  : "Правила и условия",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.locale == const Locale('uz')
                        ? '''
Sovchilar saytidan foydalanishga oid qoidalar.

Ishlatiladigan atamalar:
Ma’muriyat – sayt hodimlari hamda tegishli ravishda resurslarni boshqarishga vakolatli shaxs.
Servislar – Dasturiy ta'minotlar majmui, saytdan foydalanishda foydalanuvchilarga ko’rsatiladigan xizmatlar majmui.
Foydalanuvchi – resurslardan foydalanishni istagan, 18 yoshdan oshgan shaxslar.
Login – foydalanuvchi ro’yxatdan o’tayotganda tanlagan va saytdan foydalanish jarayonida foydalanadigan ism.
Parol – foydalanuvchi tomonidan mustaqil tanlangan resursdan foydalanishda va login bilan uning identifikatsiya uyg’unligini ta’minlaydigan kombinatsiya ramzi.
Umumiy qoidalar:
Ushbu qoidalar Foydalanuvchilarning saytdan foydalanish, shuningdek, saytdan va servisdan foydalanish jarayonida paydo bo’ladigan o’zaro munosabartlar tartibini yo’lga qo’yadi.

Maxfiy axborot:
Maxfiy axborot deb saytning foydalanuvchidan, ularning saytga kirgan vaqtda olingan va/yoki servislardan foydalangandagi identifikatsiyalashgan axborotlarga aytiladi.'''
                        : '''
Правила пользования сайтом Sovchilar.

Используемые термины: 
Администрация – сотрудники сайта и лица, уполномоченные управлять ресурсами.  
Сервисы – программное обеспечение и комплекс услуг, предоставляемых пользователям сайта.  
Пользователь – лицо старше 18 лет, желающее воспользоваться ресурсами сайта.  
Логин – имя, выбранное пользователем при регистрации и используемое при входе на сайт.  
Пароль – комбинация символов, выбранная пользователем для обеспечения идентификации вместе с логином.  

Общие правила: 
Настоящие правила регулируют отношения между пользователями и администрацией в процессе использования сайта и сервисов.  

Конфиденциальная информация:
Под конфиденциальной информацией понимаются данные, полученные от пользователя во время посещения сайта и/или использования сервисов, позволяющие его идентифицировать.''',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            actions: [
              AppButton(color: AppColors.primary, text: LocaleKeys.auth_FormTwo_terms_label.tr(), onPressed: onPressed)
            ],
          );
        },
      );
    },
  );
}
