import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sovchilar/translations/locale_keys.g.dart';

import '../../config/core/app_colors.dart';
import '../../config/routes/route_names.dart';
import '../../domain/repositories/auth_repo.dart';
import '../auth_page/component/text_fild.dart';
import '../questionnaire_page/component/app_button.dart';

class NewPassPage extends StatefulWidget {
  const NewPassPage({super.key});

  @override
  State<NewPassPage> createState() => _NewPassPageState();
}

class _NewPassPageState extends State<NewPassPage> {
  String password = '';

  String phone = '';
  String verificationToken = '';

  bool isLoading = false;
  bool _argumentsLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_argumentsLoaded) return;

    final args = ModalRoute.of(context)?.settings.arguments;

    debugPrint('NEW PASS ARGUMENTS: $args');

    if (args is Map<String, dynamic>) {
      phone = args['phone']?.toString() ?? '';
      verificationToken =
          args['verificationToken']?.toString() ?? '';
    }

    _argumentsLoaded = true;

    debugPrint('RESET PHONE: $phone');
    debugPrint(
      'RESET VERIFICATION TOKEN: $verificationToken',
    );
  }

  Future<void> _resetPassword(
      AuthGetUserRepo repo,
      ) async {
    // Parol validation
    if (password.length < 6) {
      _showError(
        'Parol kamida 6 ta belgidan iborat bo‘lishi kerak',
      );
      return;
    }

    // Phone validation
    if (phone.isEmpty) {
      _showError(
        'Telefon raqam topilmadi',
      );
      return;
    }

    // Verification token validation
    if (verificationToken.isEmpty) {
      _showError(
        'Verification token topilmadi',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      debugPrint('RESET PASSWORD REQUEST');
      debugPrint('PHONE: $phone');
      debugPrint(
        'VERIFICATION TOKEN: $verificationToken',
      );
      debugPrint('PASSWORD: $password');

      final bool ok = await repo.resetPassword(
        phone: phone,
        verificationToken: verificationToken,
        password: password,
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (ok) {
        debugPrint(
          'RESET PASSWORD SUCCESS',
        );

        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.auth,
              (route) => false,
        );
      } else {
        _showError(
          'Parolni o‘zgartirishda xatolik yuz berdi',
        );
      }
    } catch (e) {
      debugPrint(
        'RESET PASSWORD ERROR: $e',
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showError(
        'Server bilan bog‘lanishda xatolik yuz berdi',
      );
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthGetUserRepo repo =
    RepositoryProvider.of<AuthGetUserRepo>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30.w,
                vertical: 20.h,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                  MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      40.h,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys
                            .login_placeholders_password
                            .tr(),
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(
                          color: AppColors.secondary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      40.verticalSpace,

                      CustomTextField(
                        hintText: LocaleKeys
                            .login_placeholders_password
                            .tr(),
                        text: password,
                        textInputAction:
                        TextInputAction.done,
                        keyboardType:
                        TextInputType.text,
                        onChanged: (String text) {
                          setState(() {
                            password = text;
                          });
                        },
                      ),

                      20.verticalSpace,

                      AppButton(
                        color: AppColors.cA82682,
                        text: isLoading
                            ? 'Saqlanmoqda...'
                            : LocaleKeys
                            .register_button_confirmation
                            .tr(),
                        onPressed: () {
                          if (isLoading) return;

                          _resetPassword(repo);
                        },
                        width: 300.w,
                      ),

                      10.verticalSpace,

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
                            onPressed: () {
                              if (isLoading) return;

                              Navigator.pop(context);
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
          ),
        ),
      ),
    );
  }
}