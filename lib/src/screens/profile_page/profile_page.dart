import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/another_flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sovchilar/src/config/core/app_colors.dart';
import 'package:sovchilar/src/config/core/app_images.dart';
import 'package:sovchilar/src/config/routes/app_routes.dart';
import 'package:sovchilar/src/config/routes/route_names.dart';
import 'package:sovchilar/src/data/all_data.dart';
import 'package:sovchilar/src/data/login_res.dart';
import 'package:sovchilar/src/data/payment_check.dart';
import 'package:sovchilar/src/screens/profile_page/component/data_box.dart';
import 'package:sovchilar/src/screens/profile_page/component/data_button.dart';
import 'package:sovchilar/src/screens/questionnaire_page/component/app_button.dart';
import 'package:sovchilar/src/screens/widget/inactive_status_flush_bar.dart';
import 'package:sovchilar/src/service/shared_pref/my_shared_preferences.dart';
import 'package:sovchilar/translations/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/repositories/auth_repo.dart';
import 'component/popup_menu_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    getUser();
    super.initState();
  }

  User? user;
  PaymentCheck? paymentCheck;
  bool? ok;

  Future<void> getUser() async {
    String? data = await MySharedPreferences.instance.user;
    ok = await MySharedPreferences.instance.paymentOk;
    String? paymentData = await MySharedPreferences.instance.paymentData;
    paymentCheck = PaymentCheck.fromJson(jsonDecode(paymentData!));
    LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(data!));
    user = loginResponse.data!.user;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final AuthGetUserRepo repo =
        RepositoryProvider.of<AuthGetUserRepo>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: SizedBox(),
          actions: [
            MorePopupMenuButton(
              onPressedForm: () {
                Navigator.pushNamed(context, RouteNames.addForm).then((value) {
                  getUser();
                });
              },
              status: user?.status ?? "PENDING",
            ),
            10.horizontalSpace,
          ],
          scrolledUnderElevation: 0,
        ),
        body: user != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: user?.imageUrl == '' || user?.imageUrl == null
                              ? () {}
                              : () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: Stack(
                                        children: [
                                          InteractiveViewer(
                                            child: user?.imageUrl == '' ||
                                                    user?.imageUrl == null
                                                ? Image.asset(
                                                    AppImages.male_1,
                                                  )
                                                : Image.network(
                                                    user?.imageUrl ?? "",
                                                    errorBuilder:
                                                        (_, __, ___) =>
                                                            Image.asset(
                                                      AppImages.male_1,
                                                    ),
                                                  ), // Rasmingizni pathini qo‘shing
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: IconButton(
                                              icon: Icon(
                                                CupertinoIcons
                                                    .xmark_circle_fill,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Modal oynani yopish
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                          child: Container(
                            height: 250.h,
                            width: 350.w,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.r)),
                              image: DecorationImage(
                                  image: user?.imageUrl == '' ||
                                          user?.imageUrl == null
                                      ? AssetImage(
                                          user?.gender == "MALE"
                                              ? AppImages.male_1
                                              : AppImages.female_1,
                                        )
                                      : NetworkImage(
                                          user?.imageUrl ?? "",
                                        ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                      20.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          20.verticalSpace,
                          Text(
                            '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: AppColors.secondary,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700),
                          ),
                          10.verticalSpace,
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.location_solid,
                                color: AppColors.secondary,
                              ),
                              5.horizontalSpace,
                              Text(user?.address == null
                                  ? LocaleKeys.Profile_UserProfile_city.tr()
                                  : getAddressTranslation(user?.address ?? "")),
                              3.horizontalSpace,
                              CircleAvatar(
                                radius: 3,
                                backgroundColor: AppColors.textFieldColor,
                              ),
                              3.horizontalSpace,
                              Text(user?.address == null
                                  ? LocaleKeys.Profile_UserProfile_nationality
                                      .tr()
                                  : getNationalityTranslation(
                                      user?.nationality ?? "")),
                            ],
                          ),
                          paymentCheck?.data == null || ok == false
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        child: Text(LocaleKeys.premium.tr())),
                                    3.horizontalSpace,
                                    3.horizontalSpace,
                                    AppButton(
                                      color: AppColors.red,
                                      text: LocaleKeys.activate.tr(),
                                      onPressed: () {
                                        InactiveStatusFlushBar.show(
                                          context,
                                          title: LocaleKeys.inactive.tr(),
                                          message: LocaleKeys.inactive_description.tr(),
                                        );
                                      },
                                      width: 150.w,
                                    )
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    15.verticalSpace,
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 20.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.r)),
                                        color: AppColors.golden.withAlpha(30),
                                        border: Border.all(
                                          color: AppColors.golden.withAlpha(70),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          DataBox(
                                              title:
                                                  '${LocaleKeys.boshSana.tr()}:',
                                              text: paymentCheck
                                                      ?.data?.startDate
                                                      ?.substring(0, 10) ??
                                                  ""),
                                          DataBox(
                                              title:
                                                  '${LocaleKeys.tugashKun.tr()}:',
                                              text: paymentCheck?.data?.endDate
                                                      ?.substring(0, 10) ??
                                                  ""),
                                          DataBox(
                                              title:
                                                  '${LocaleKeys.qolgan.tr()}:',
                                              text:
                                                  '${daysBetween(paymentCheck?.data?.endDate ?? "")} ${LocaleKeys.kun.tr()}'),
                                        ],
                                      ),
                                    ),
                                    10.verticalSpace,
                                    AppButton(
                                      color: AppColors.red,
                                      text: LocaleKeys.uzaytirish.tr(),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, RouteNames.payment);
                                      },
                                      width: 150.w,
                                    )
                                  ],
                                ),
                        ],
                      ),
                      20.verticalSpace,
                      Text(
                        LocaleKeys.userCard_description.tr(),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      10.verticalSpace,
                      Text(user?.description ??
                          LocaleKeys.Profile_UserProfile_comment.tr()),
                      10.verticalSpace,
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              user?.numerIsVisible != null &&
                                      user?.numerIsVisible != false
                                  ? LocaleKeys.Profile_UserProfile_hiddenPhone
                                      .tr()
                                  : LocaleKeys.Profile_UserProfile_showPhone
                                      .tr(),
                              maxLines: 4,
                            ),
                          ),
                          20.horizontalSpace,
                          CupertinoSwitch(
                              value: user?.numerIsVisible ?? false,
                              onChanged: (bool newValue) async {
                                await repo.numberIsVisible(
                                    numberIsVisible: newValue);
                                getUser();
                              }),
                        ],
                      ),
                      20.verticalSpace,
                      Text(
                        LocaleKeys.UserDetails_mainInfo.tr(),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      10.verticalSpace,
                      DataBox(
                        title: LocaleKeys.UserDetails_age.tr(),
                        text: user?.age != null
                            ? user!.age!.toString()
                            : LocaleKeys.Profile_UserProfile_age.tr(),
                      ),
                      10.verticalSpace,
                      DataBox(
                        title: LocaleKeys.UserDetails_location.tr(),
                        text: user?.address == null
                            ? LocaleKeys.Profile_UserProfile_address.tr()
                            : getAddressTranslation(user?.address ?? ""),
                      ),
                      10.verticalSpace,
                      DataBox(
                        title: LocaleKeys.UserDetails_education.tr(),
                        text: user?.qualification == null
                            ? LocaleKeys.Profile_UserProfile_education.tr()
                            : getDegreeTranslation(user?.qualification ?? ""),
                      ),
                      10.verticalSpace,
                      DataBox(
                        title: LocaleKeys.UserDetails_work.tr(),
                        text: user?.jobTitle ??
                            LocaleKeys.Profile_UserProfile_occupation.tr(),
                      ),
                      10.verticalSpace,
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            10.verticalSpace,
                            DataButton(
                              title: LocaleKeys.UserDetails_status.tr(),
                              text: user?.status == 'ACTIVE'
                                  ? LocaleKeys.UserDetails_activeStatus.tr()
                                  : LocaleKeys.UserDetails_inactive.tr(),
                              iconData: CupertinoIcons.plus,
                              onPressed: () {},
                              color: AppColors.golden.withOpacity(0.3),
                            ),
                            10.verticalSpace,
                            DataButton(
                              title: LocaleKeys.UserDetails_nationality.tr(),
                              text: user?.nationality == null
                                  ? LocaleKeys.Profile_UserProfile_ethnicity
                                      .tr()
                                  : getNationalityTranslation(
                                      user?.nationality ?? ""),
                              iconData: CupertinoIcons.plus,
                              onPressed: () {},
                              color: AppColors.green.withOpacity(0.3),
                            ),
                            10.verticalSpace,
                            DataButton(
                              title: LocaleKeys.UserDetails_telegram.tr(),
                              text: user?.telegram ??
                                  LocaleKeys.Profile_UserProfile_telegram.tr(),
                              iconData: Icons.telegram,
                              onPressed: () async {
                                if (user?.telegram != '' &&
                                    user?.telegram != null) {
                                  final Uri tg_url = Uri.parse(
                                      "https://${user?.telegram ?? ''}");
                                  await launchUrl(tg_url,
                                      mode: LaunchMode.externalApplication);
                                }
                              },
                              color: AppColors.cF79E1B.withOpacity(0.3),
                            ),
                            10.verticalSpace,
                            user?.phone != null
                                ? DataButton(
                                    title: LocaleKeys.UserDetails_phone.tr(),
                                    text: user!.numerIsVisible!
                                        ? "**** ** *** ** **" ?? ''
                                        : user?.phone ?? "",
                                    iconData: CupertinoIcons.phone,
                                    onPressed: user!.numerIsVisible!
                                        ? () {}
                                        : () async {
                                            if (user?.phone != '' &&
                                                user?.phone != null) {
                                              final Uri tg_url = Uri(
                                                  scheme: 'tel',
                                                  path: user?.telegram ?? '');
                                              await launchUrl(tg_url,
                                                  mode: LaunchMode
                                                      .externalApplication);
                                            }
                                          },
                                    color: AppColors.green.withOpacity(0.3),
                                  )
                                : SizedBox(),
                            10.verticalSpace
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: Platform.isIOS
                    ? CupertinoActivityIndicator() // iOS platformasida
                    : CircularProgressIndicator()),
      ),
    );
  }
}

daysBetween(String dateStr2) {
  DateTime dt1 = DateTime.now();
  DateTime dt2 = DateTime.parse(dateStr2);
  return dt2.difference(dt1).inDays;
}
