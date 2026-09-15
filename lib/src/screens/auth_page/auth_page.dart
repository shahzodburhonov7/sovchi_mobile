import 'package:another_flushbar/another_flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sovchilar/src/config/core/app_colors.dart';
import 'package:sovchilar/src/config/core/app_images.dart';
import 'package:sovchilar/src/config/routes/route_names.dart';
import 'package:sovchilar/src/data/login_res.dart';
import 'package:sovchilar/src/domain/repositories/auth_repo.dart';
import 'package:sovchilar/src/screens/questionnaire_page/component/app_button.dart';
import 'package:sovchilar/src/screens/widget/inactive_status_flush_bar.dart';
import 'package:sovchilar/src/service/shared_pref/my_shared_preferences.dart';
import 'package:sovchilar/translations/locale_keys.g.dart';

import '../../config/core/app_icons.dart';
import 'component/text_fild.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String login = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final AuthGetUserRepo repo =
        RepositoryProvider.of<AuthGetUserRepo>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 170.w,
          leading: Row(
            children: [
              30.horizontalSpace,
              PopupMenuButton(
                onOpened: () {},
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: PopupMenuItemView(
                      icon: AppIcons.ru,
                      text: LocaleKeys.russian.tr(),
                    ),
                    onTap: () async {
                      await context.setLocale(const Locale('ru'));
                    },
                  ),
                  PopupMenuItem(
                    child: PopupMenuItemView(
                      icon: AppIcons.uz,
                      text: LocaleKeys.uzbek.tr(),
                    ),
                    onTap: () async {
                      await context.setLocale(const Locale('uz'));
                    },
                  ),
                ],
                position: PopupMenuPosition.under,
                color: AppColors.grey.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                elevation: 0,
                clipBehavior: Clip.antiAlias,
                child: context.locale == const Locale('ru')
                    ? PopupMenuChildView(
                        icon: AppIcons.ru,
                        text: LocaleKeys.russian.tr(),
                      )
                    : PopupMenuChildView(
                        icon: AppIcons.uz,
                        text: LocaleKeys.uzbek.tr(),
                      ),
              ),
            ],
          ),
        ),
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
                        LocaleKeys.login_title.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(
                          color: AppColors.secondary,
                        ),
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

                      CustomTextField(
                        text: password,
                        hintText:
                        LocaleKeys.login_placeholders_password.tr(),
                        password: true,
                        onChanged: (String text) {
                          password = text;
                          setState(() {});
                        },
                        textInputAction: TextInputAction.done,
                      ),

                      20.verticalSpace,

                      AppButton(
                        color: AppColors.cA82682,
                        text: LocaleKeys.login_button_text.tr(),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();

                          if (login.length != 9) {
                            InactiveStatusFlushBar.show(
                              context,
                              title: LocaleKeys.auth_ErrorModal_title.tr(),
                              message:
                              LocaleKeys.login_placeholders_phone.tr(),
                            );

                            return;
                          }

                          if (password.isEmpty) {
                            InactiveStatusFlushBar.show(
                              context,
                              title: LocaleKeys.auth_ErrorModal_title.tr(),
                              message:
                              LocaleKeys.login_placeholders_password.tr(),

                            );

                            return;
                          }

                          final bool ok = await repo.logInRequest(
                            phoneNumber: '+998$login',
                            password: password,
                          );

                          if (ok) {
                            await MySharedPreferences.instance.saveProfile(true);

                            if (!context.mounted) return;

                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              RouteNames.home,
                                  (route) => false,
                            );
                          } else {
                            if (!context.mounted) return;
                            InactiveStatusFlushBar.show(
                              context,
                              title: LocaleKeys.auth_ErrorModal_title.tr(),
                              message:
                              repo.lastErrorMessage ?? "Raqam yoki parol xato",
                            );

                          }
                        },
                        width: 300.w,
                      ),

                      10.verticalSpace,

                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.forgetPass,
                          );
                        },
                        child: Text(
                          LocaleKeys.login_forgotPassword.tr(),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            LocaleKeys.login_links_text.tr(),
                          ),
                          5.horizontalSpace,
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                RouteNames.regPage,
                              );
                            },
                            child: Text(
                              LocaleKeys.login_links_link.tr(),
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

class PopupMenuChildView extends StatelessWidget {
  final String icon;
  final String text;

  const PopupMenuChildView({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.08),
          borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: 20.h,
              width: 28.w,
            ),
            SizedBox(
              width: 8.w,
            ),
            Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.cA82682),
            ),
          ],
        ),
      ),
    );
  }
}

class PopupMenuItemView extends StatelessWidget {
  final String icon;
  final String text;

  const PopupMenuItemView({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.w,
      height: 24.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            icon,
            height: 20.h,
            width: 28.w,
          ),
          SizedBox(
            width: 8.w,
          ),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.secondary),
          ),
        ],
      ),
    );
  }
}

Future<void> showErrorDialog(
    {required BuildContext context,
    required String text,
    bool duration = true}) async {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(text),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      );
    },
  );
  if (duration) {
    Future.delayed(Duration(seconds: 2), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }
}

