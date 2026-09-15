import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sovchilar/src/data/all_data.dart';
import 'package:sovchilar/src/data/login_res.dart';

import '../../../translations/locale_keys.g.dart';
import '../../config/core/app_colors.dart';
import '../../config/routes/route_names.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../service/shared_pref/my_shared_preferences.dart';
import '../auth_page/component/text_fild.dart';
import '../questionnaire_page/component/app_button.dart';
import '../reg_page/reg_page.dart';

class RegQuestionnairePage extends StatefulWidget {
  const RegQuestionnairePage({super.key});

  @override
  State<RegQuestionnairePage> createState() =>
      _RegQuestionnairePageState();
}

bool registerAddQues = false;

class _RegQuestionnairePageState
    extends State<RegQuestionnairePage> {
  String firstName = '';
  String password = '';

  String login = regData;

  String? selectedGender;

  // Telegram verification
  String? phone;
  String? verificationToken;
  String? telegramUsername;

  bool isLoading = false;

  final List<String> genders = [
    'FEMALE',
    'MALE',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments =
        ModalRoute.of(context)?.settings.arguments;

    if (arguments is Map<String, dynamic>) {
      phone = arguments['phone']?.toString();
      verificationToken =
          arguments['verificationToken']?.toString();
      telegramUsername =
          arguments['telegramUsername']?.toString();

      debugPrint(
        'REGISTRATION PHONE: $phone',
      );

      debugPrint(
        'VERIFICATION TOKEN: $verificationToken',
      );

      debugPrint(
        'TELEGRAM USERNAME: $telegramUsername',
      );
    }
  }

  // ============================================================
  // REGISTER
  // ============================================================

  Future<void> _register(AuthGetUserRepo repo) async {
    if (firstName.trim().length < 2) {
      _showMessage(
        "Ismni to'g'ri kiriting",
      );
      return;
    }

    if (password.length < 6) {
      _showMessage(
        "Parol kamida 6 ta belgidan iborat bo'lishi kerak",
      );
      return;
    }

    if (selectedGender == null) {
      _showMessage(
        "Jinsni tanlang",
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      LoginResponse? loginResponse;

      // ========================================================
      // TELEGRAM REGISTER
      // ========================================================

      if (phone != null &&
          phone!.isNotEmpty &&
          verificationToken != null &&
          verificationToken!.isNotEmpty) {
        debugPrint(
          'REGISTER VIA TELEGRAM',
        );

        debugPrint(
          'phone: $phone',
        );

        debugPrint(
          'verificationToken: $verificationToken',
        );

        loginResponse = await repo.register(
          phone: phone!,
          verificationToken: verificationToken!,
          firstName: firstName.trim(),
          lastName: '',
          password: password,
          gender: selectedGender!,
        );
      }

      // ========================================================
      // OLD EMAIL REGISTER
      // ========================================================

      else {
        debugPrint(
          'REGISTER VIA EMAIL',
        );

        loginResponse = await repo.createUser(
          firstName: firstName.trim(),
          password: password,
          gender: selectedGender!,
          phone: regData.contains('+998')
              ? regData
              : null,
          email: regData.contains('+998')
              ? null
              : regData,
        );
      }

      // ========================================================
      // SUCCESS
      // ========================================================

      if (loginResponse != null) {
        await MySharedPreferences.instance
            .saveProfile(true);

        registerAddQues = true;

        if (!mounted) return;

        Navigator.pushNamed(
          context,
          RouteNames.addForm,
        );
      } else {
        if (!mounted) return;

        _showMessage(
          "Ro'yxatdan o'tishda xatolik yuz berdi",
        );
      }
    } catch (e) {
      debugPrint(
        'REGISTER ERROR: $e',
      );

      if (!mounted) return;

      _showMessage(
        "Ro'yxatdan o'tishda xatolik yuz berdi",
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final AuthGetUserRepo repo =
    RepositoryProvider.of<AuthGetUserRepo>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30.w,
            vertical: 20.w,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ==================================================
                // TITLE
                // ==================================================

                Text(
                  LocaleKeys.register_title_signup.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(
                    color: AppColors.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                40.verticalSpace,

                // ==================================================
                // FIRST NAME
                // ==================================================

                CustomTextField(
                  hintText: LocaleKeys
                      .register_placeholders_firstName
                      .tr(),
                  text: firstName,
                  textInputAction:
                  TextInputAction.next,
                  keyboardType:
                  TextInputType.text,
                  onChanged: (String text) {
                    firstName = text;
                  },
                ),

                20.verticalSpace,

                // ==================================================
                // PASSWORD
                // ==================================================

                CustomTextField(
                  hintText: LocaleKeys
                      .register_placeholders_password
                      .tr(),
                  text: password,
                  password: true,
                  textInputAction:
                  TextInputAction.done,
                  keyboardType:
                  TextInputType.text,
                  onChanged: (String text) {
                    password = text;
                  },
                ),

                20.verticalSpace,

                // ==================================================
                // GENDER
                // ==================================================

                SizedBox(
                  width: 300.w,
                  child: DropdownButtonFormField<String>(
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color: AppColors.secondary,
                    ),
                    decoration: InputDecoration(
                      floatingLabelBehavior:
                      FloatingLabelBehavior.never,
                      prefixStyle: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 16.sp,
                      ),
                      counterText: '',
                      hintText: LocaleKeys
                          .register_select_gender
                          .tr(),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        color: AppColors.grey,
                        fontSize: 16.sp,
                      ),
                      contentPadding:
                      EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 12.h,
                      ),
                      enabledBorder:
                      OutlineInputBorder(
                        borderSide:
                        const BorderSide(
                          color:
                          AppColors.textFieldColor,
                          width: 1.5,
                        ),
                        borderRadius:
                        BorderRadius.circular(12.r),
                      ),
                      disabledBorder:
                      OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors
                              .textFieldColor
                              .withOpacity(0.5),
                          width: 1.5,
                        ),
                        borderRadius:
                        BorderRadius.circular(12.r),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                        const BorderSide(
                          color:
                          AppColors.textFieldColor,
                          width: 1.5,
                        ),
                        borderRadius:
                        BorderRadius.circular(12.r),
                      ),
                    ),
                    value: selectedGender,
                    isExpanded: true,
                    items: genders.map((gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(
                          getGenderTranslation(
                            gender,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: isLoading
                        ? null
                        : (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),
                ),

                20.verticalSpace,

                // ==================================================
                // REGISTER BUTTON
                // ==================================================

                AppButton(
                  color: AppColors.cA82682,
                  text: isLoading
                      ? "..."
                      : LocaleKeys
                      .register_button_signup
                      .tr(),
                  onPressed: () {
                    if (isLoading) return;

                    _register(repo);
                  },
                  width: 300.w,
                ),

                10.verticalSpace,

                // ==================================================
                // LOGIN
                // ==================================================

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys
                          .register_link_text
                          .tr(),
                    ),
                    5.horizontalSpace,
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                        Navigator
                            .pushNamedAndRemoveUntil(
                          context,
                          RouteNames.auth,
                              (route) => false,
                        );
                      },
                      child: Text(
                        LocaleKeys
                            .login_title
                            .tr(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}