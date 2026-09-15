import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sovchilar/src/config/core/app_icons.dart';
import 'package:sovchilar/translations/locale_keys.g.dart';

import '../../../config/core/app_colors.dart';
import '../../../config/routes/route_names.dart';
import '../../../data/all_data.dart';
import '../../../domain/repositories/auth_repo.dart';
import '../../../service/shared_pref/my_shared_preferences.dart';
import '../../home_screen/home_screen.dart';
import '../../questionnaire_page/component/app_button.dart';

class MorePopupMenuButton extends StatefulWidget {
  const MorePopupMenuButton(
      {super.key, required this.onPressedForm, required this.status});

  final VoidCallback onPressedForm;
  final String status;

  @override
  State<MorePopupMenuButton> createState() => _MorePopupMenuButtonState();
}

class _MorePopupMenuButtonState extends State<MorePopupMenuButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.all(10.w),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: widget.onPressedForm,
          child: Text(
            widget.status == "PENDING"
                ? LocaleKeys.Profile_btn_add.tr()
                : LocaleKeys.Profile_btn_edit.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        PopupMenuItem(
                onTap:widget.status == "ACTIVE"
                    ? () async {
                  HapticFeedback.lightImpact();
                  if (await onFound(context)) {
                    setState(() {});
                  }
                }:(){},
                child: Text(
                  LocaleKeys.Profile_modal_happiness_found.tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
        PopupMenuItem(
          child: context.locale == const Locale('ru')
              ? Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.ru,
                      height: 20.h,
                      width: 28.w,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      LocaleKeys.russian.tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                  ],
                )
              : Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.uz,
                      height: 20.h,
                      width: 28.w,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      LocaleKeys.uzbek.tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                  ],
                ),
          onTap: () async {
            if (context.locale == const Locale('ru')) {
              await context.setLocale(const Locale('uz'));
            } else {
              await context.setLocale(const Locale('ru'));
            }
          },
        ),
        PopupMenuItem(
          child: Text(
            LocaleKeys.Profile_btn_logout.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onTap: () async {
            HapticFeedback.lightImpact();
            if (await onBackButtonPressed(context)) {
              await MySharedPreferences.instance.preferences.clear();
              MySharedPreferences.instance.saveProfile(false);
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteNames.auth, (route) => false);
            }
          },
        ),
      ],
      position: PopupMenuPosition.under,
      constraints: BoxConstraints(minWidth: 25.w, minHeight: 20.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      color: Colors.white,
      elevation: 10,

      clipBehavior: Clip.antiAlias,
      child: Icon(Icons.more_vert_outlined),
    );
  }
}

Future<bool> onBackButtonPressed(BuildContext context) async {
  bool? exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            LocaleKeys.Profile_btn_logout.tr(),
            textAlign: TextAlign.center,
          ),
          titleTextStyle: Theme.of(context).textTheme.displayMedium,
          contentTextStyle: TextStyle(color: AppColors.secondary, fontSize: 16.sp),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            Row(
              children: [
                AppButton(
                  color: AppColors.alert,
                  text: LocaleKeys.Profile_form_cancel.tr(),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  textColor: AppColors.primary,
                  width: 115.w,
                  hasBorder: true,
                ),
                20.horizontalSpace,
                AppButton(
                  color: AppColors.primary,
                  text: LocaleKeys.Profile_form_confirm.tr(),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  width: 115.w,
                ),
              ],
            ),
          ],
        );
      });
  return exitApp ?? false;
}

Future<bool> onFound(BuildContext context) async {
  final AuthGetUserRepo repo = RepositoryProvider.of<AuthGetUserRepo>(context);
  bool? exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            LocaleKeys.Profile_modal_happiness_title.tr(),
            textAlign: TextAlign.center,
          ),
          titleTextStyle: Theme.of(context).textTheme.displayMedium,
          content: Text(
            LocaleKeys.Profile_modal_happiness_message.tr(),
            textAlign: TextAlign.center,
          ),
          contentTextStyle: TextStyle(color: AppColors.secondary, fontSize: 14.sp),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            Row(
              children: [
                AppButton(
                  color: AppColors.alert,
                  text: LocaleKeys.Profile_form_cancel.tr(),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  textColor: AppColors.primary,
                  width: 115.w,
                  hasBorder: true,
                ),
                20.horizontalSpace,
                AppButton(
                  color: AppColors.primary,
                  text: LocaleKeys.Profile_form_confirm.tr(),
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                    await repo.statusChange(statusChange: "DONE");
                  },
                  width: 115.w,
                ),
              ],
            ),
          ],
        );
      });
  return exitApp ?? false;
}
