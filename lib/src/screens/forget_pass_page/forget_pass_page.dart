import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sovchilar/src/config/routes/route_names.dart';
import 'package:sovchilar/translations/locale_keys.g.dart';

import '../../config/core/app_colors.dart';
import '../../domain/repositories/auth_repo.dart';
import '../auth_page/component/text_fild.dart';
import '../questionnaire_page/component/app_button.dart';

class ForgetPassPage extends StatefulWidget {
  const ForgetPassPage({super.key});

  @override
  State<ForgetPassPage> createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends State<ForgetPassPage> {
  String login = '';

  Timer? pollingTimer;

  bool isLoading = false;

  @override
  void dispose() {
    pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _startTelegramVerification(
      AuthGetUserRepo repo,
      ) async {
    if (login.length != 9) {
      _showError('Telefon raqamni to‘liq kiriting');
      return;
    }

    final phone = '+998$login';

    setState(() {
      isLoading = true;
    });

    try {
      final result = await repo.verifyStart(
        phone: phone,
      );

      debugPrint("VERIFY START: $result");

      final sessionId = result['sessionId'];
      final deepLink = result['deepLink'];

      if (sessionId == null || deepLink == null) {
        _showError(
          result['message']?.toString() ??
              'Telegram verification boshlanmadi',
        );

        setState(() {
          isLoading = false;
        });

        return;
      }

      final Uri telegramUrl = Uri.parse(
        deepLink.toString(),
      );

      if (await canLaunchUrl(telegramUrl)) {
        await launchUrl(
          telegramUrl,
          mode: LaunchMode.externalApplication,
        );

        _startPolling(
          repo,
          sessionId.toString(),
          phone,
        );
      } else {
        _showError('Telegram ilovasini ochib bo‘lmadi');

        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("VERIFY START ERROR: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showError(
        'Telegram verificationni boshlashda xatolik yuz berdi',
      );
    }
  }

  void _startPolling(
      AuthGetUserRepo repo,
      String sessionId,
      String phone,
      ) {
    pollingTimer?.cancel();

    pollingTimer = Timer.periodic(
      const Duration(seconds: 2),
          (timer) async {
        try {
          final result = await repo.verifyStatus(
            sessionId: sessionId,
          );

          debugPrint("VERIFY STATUS: $result");

          final status = result['status']?.toString();

          if (status == 'verified') {
            timer.cancel();

            // Backend "token" nomi bilan qaytaryapti
            final verificationToken =
                result['token']?.toString() ?? '';

            // Backend tasdiqlangan telefonni ham qaytaryapti
            final verifiedPhone =
                result['phone']?.toString() ?? phone;

            debugPrint('VERIFIED PHONE: $verifiedPhone');
            debugPrint('VERIFIED TOKEN: $verificationToken');

            if (verificationToken.isEmpty) {
              if (!mounted) return;

              setState(() {
                isLoading = false;
              });

              _showError('Verification token olinmadi');
              return;
            }

            if (!mounted) return;

            setState(() {
              isLoading = false;
            });

            Navigator.pushNamed(
              context,
              RouteNames.newPass,
              arguments: {
                'phone': verifiedPhone,
                'verificationToken': verificationToken,
              },
            );
          }

          if (status == 'mismatch') {
            timer.cancel();

            if (!mounted) return;

            setState(() {
              isLoading = false;
            });

            _showError(
              'Telegramdagi raqam kiritilgan raqamga mos kelmaydi',
            );
          }

          if (status == 'expired') {
            timer.cancel();

            if (!mounted) return;

            setState(() {
              isLoading = false;
            });

            _showError(
              'Verification muddati tugadi. Qaytadan urinib ko‘ring.',
            );
          }
        } catch (e) {
          debugPrint("VERIFY STATUS ERROR: $e");
        }
      },
    );
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
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
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30.w,
                vertical: 20.h,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      40.h,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.register_title_number.tr(),
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
                        prefixText: '+998 ',
                        regPage: true,
                        text: login,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        onChanged: (String text) {
                          login = text.replaceAll(RegExp(r'\D'), '');
                        },
                      ),

                      20.verticalSpace,

                      AppButton(
                        color: AppColors.cA82682,
                        text: isLoading
                            ? 'Telegramni tekshirish...'
                            : LocaleKeys
                            .register_button_number
                            .tr(),
                        onPressed: () {
                          if (isLoading) return;

                          _startTelegramVerification(repo);
                        },
                        width: 300.w,
                      ),

                      10.verticalSpace,

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Text(
                            LocaleKeys.register_link_text.tr(),
                          ),
                          5.horizontalSpace,
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              LocaleKeys.login_title.tr(),
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