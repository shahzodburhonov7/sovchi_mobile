import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sovchilar/src/config/routes/route_names.dart';
import 'package:sovchilar/src/screens/widget/inactive_status_flush_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../translations/locale_keys.g.dart';
import '../../config/core/app_colors.dart';
import '../../domain/repositories/auth_repo.dart';
import '../auth_page/component/text_fild.dart';
import '../questionnaire_page/component/app_button.dart';

class RegPage extends StatefulWidget {
  const RegPage({super.key});

  @override
  State<RegPage> createState() => _RegPageState();
}

String regData = '';

class _RegPageState extends State<RegPage> {
  String phone = '';
  String email = '';

  bool withEmail = false;
  bool isLoading = false;

  String? sessionId;

  Timer? pollingTimer;

  @override
  void dispose() {
    pollingTimer?.cancel();
    super.dispose();
  }

  // ============================================================
  // TELEGRAM VERIFICATION START
  // ============================================================
  void _showMessage(String message) {
    if (!mounted) return;

    InactiveStatusFlushBar.show(
      context,
      title: 'Ogohlantirish',
      message: message,
    );
  }

  Future<void> _startTelegramVerification(
      AuthGetUserRepo repo,
      ) async {
    if (phone.length != 9) {
      _showMessage(
        "Telefon raqamni to'liq kiriting",
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });

    try {
      final String fullPhone = '+998$phone';

      // ============================================================
      // 1. USER BOR-YO'QLIGINI TEKSHIRAMIZ
      // ============================================================

      final bool isRegistered = await repo.isPhoneRegistered(
        phone: fullPhone,
      );

      debugPrint(
        'PHONE REGISTERED: $isRegistered',
      );

      if (isRegistered) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          _showMessage(
            "Bu telefon raqam allaqachon ro'yxatdan o'tgan.\n"
                "Iltimos, Kirish bo'limidan foydalaning.",
          );
        });

        return;
      }

      // ============================================================
      // 2. USER YO'Q → TELEGRAM VERIFICATION
      // ============================================================

      final result = await repo.verifyStart(
        phone: fullPhone,
      );

      debugPrint(
        'VERIFY START: $result',
      );

      final String? newSessionId =
      result['sessionId']?.toString();

      final String? deepLink =
      result['deepLink']?.toString();

      if (newSessionId == null ||
          newSessionId.isEmpty) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        _showMessage(
          "Verification session yaratilmadi",
        );

        return;
      }

      if (deepLink == null || deepLink.isEmpty) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        _showMessage(
          "Telegram havolasi olinmadi",
        );

        return;
      }

      sessionId = newSessionId;

      final Uri uri = Uri.parse(deepLink);

      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        _showMessage(
          "Telegram ilovasini ochib bo'lmadi",
        );

        return;
      }

      _startPolling(repo);
    } catch (e) {
      debugPrint(
        'REGISTER PHONE CHECK ERROR: $e',
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showMessage(
        "Xatolik yuz berdi. Qaytadan urinib ko'ring.",
      );
    }
  }

  // ============================================================
  // TELEGRAM STATUS POLLING
  // ============================================================

  void _startPolling(
      AuthGetUserRepo repo,
      ) {
    pollingTimer?.cancel();

    pollingTimer = Timer.periodic(
      const Duration(seconds: 2),
          (timer) async {
        if (!mounted || sessionId == null) {
          timer.cancel();
          return;
        }

        try {
          final result = await repo.verifyStatus(
            sessionId: sessionId!,
          );

          debugPrint(
            'VERIFY STATUS: $result',
          );

          final String status =
              result['status']?.toString() ?? '';

          // ====================================================
          // PENDING
          // ====================================================

          if (status == 'pending') {
            return;
          }

          // ====================================================
          // AWAITING CONTACT
          // ====================================================

          if (status == 'awaiting_contact') {
            return;
          }

          // ====================================================
          // VERIFIED
          // ====================================================

          if (status == 'verified') {
            timer.cancel();

            final String verifiedPhone =
                result['phone']?.toString() ?? '';

            final String verificationToken =
                result['token']?.toString() ?? '';

            final String telegramUsername =
                result['telegramUsername']?.toString() ?? '';

            debugPrint(
              'TELEGRAM VERIFIED',
            );

            debugPrint(
              'PHONE: $verifiedPhone',
            );

            debugPrint(
              'TOKEN: $verificationToken',
            );




            ;

            setState(() {
              isLoading = false;
            });

            regData = verifiedPhone;

            // ==================================================
            // BU YERDA ANKETA ROUTE'IGA O'TAMIZ
            // ==================================================

            Navigator.pushNamed(
              context,
              RouteNames.regQues,
              arguments: {
                'phone': verifiedPhone,
                'verificationToken': verificationToken,
                'telegramUsername': telegramUsername,
              },
            );

            return;
          }

          // ====================================================
          // MISMATCH
          // ====================================================

          if (status == 'mismatch') {
            timer.cancel();

            if (!mounted) return;

            setState(() {
              isLoading = false;
            });

            _showMessage(
              "Telegramdagi raqam mos kelmadi.",
            );

            return;
          }

          // ====================================================
          // EXPIRED
          // ====================================================

          if (status == 'expired') {
            timer.cancel();

            if (!mounted) return;

            setState(() {
              isLoading = false;
            });

            _showMessage(
              "Tasdiqlash vaqti tugadi.",
            );

            return;
          }
        } catch (e) {
          debugPrint(
            'VERIFY STATUS ERROR: $e',
          );
        }
      },
    );
  }

  // ============================================================
  // EMAIL REGISTER
  // ============================================================

  Future<void> _registerWithEmail(
      AuthGetUserRepo repo,
      ) async {
    if (email.trim().isEmpty) {
      _showMessage("Email kiriting");
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });

    try {
      final bool ok = await repo.findByEmailAuth(
        email: email.trim(),
      );

      if (!ok) {
        setState(() {
          isLoading = false;
        });

        return;
      }

      await repo.regWithEmail(
        email: email.trim(),
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      regData = email.trim();

      Navigator.pushNamed(
        context,
        RouteNames.otp,
        arguments: email.trim(),
      );
    } catch (e) {
      debugPrint(
        'EMAIL REGISTER ERROR: $e',
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showMessage(
        "Xatolik yuz berdi.",
      );
    }
  }

  // ============================================================
  // BUTTON
  // ============================================================

  Future<void> _onPressed(
      AuthGetUserRepo repo,
      ) async {
    if (isLoading) return;

    if (withEmail) {
      await _registerWithEmail(repo);
    } else {
      await _startTelegramVerification(repo);
    }
  }

  // ============================================================
  // SNACKBAR
  // ============================================================


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

                // ==================================================
                // FIELD
                // ==================================================

                withEmail
                    ? CustomTextField(
                  hintText: LocaleKeys
                      .register_placeholders_emailregister
                      .tr(),
                  text: email,
                  textInputAction:
                  TextInputAction.next,
                  keyboardType:
                  TextInputType.emailAddress,
                  onChanged: (String text) {
                    email = text;
                  },
                )
                    :

                CustomTextField(
                  prefixText: '+998 ',
                  regPage: true,
                  text: phone,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  onChanged: (String text) {
                    phone = text.replaceAll(RegExp(r'\D'), '');
                  },
                ),

                20.verticalSpace,

                // ==================================================
                // REGISTER BUTTON
                // ==================================================

                AppButton(
                  color: AppColors.cA82682,
                  text: isLoading
                      ? "Telegram..."
                      : LocaleKeys.register_button_number.tr(),
                  onPressed: () {
                    if (isLoading) return;

                    _onPressed(repo);
                  },
                  width: 300.w,
                ),

                10.verticalSpace,

                // ==================================================
                // PHONE / EMAIL
                // ==================================================

                withEmail
                    ? TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                    FocusScope.of(context)
                        .unfocus();

                    setState(() {
                      withEmail = false;
                      email = '';
                    });
                  },
                  child: Text(
                    LocaleKeys
                        .register_button_byNomer
                        .tr(),
                  ),
                )
                    : TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                    FocusScope.of(context)
                        .unfocus();

                    setState(() {
                      withEmail = true;
                      phone = '';
                    });
                  },
                  child: Text(
                    LocaleKeys
                        .register_button_byEmail
                        .tr(),
                  ),
                ),

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
    );
  }
}