import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sovchilar/src/data/all_data.dart';
import 'package:sovchilar/src/data/profile_user.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../translations/locale_keys.g.dart';
import '../../config/core/app_colors.dart';
import '../../config/core/app_images.dart';
import '../../domain/repositories/auth_repo.dart';
import '../profile_page/component/data_box.dart';
import '../profile_page/component/data_button.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, required this.id,required this.assetImage});

  final String id;
  final String assetImage;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  UserProfile? userProfile;

  Future<void> getUser() async {
    final AuthGetUserRepo repo =
        RepositoryProvider.of<AuthGetUserRepo>(context);
    userProfile = await repo.getUserProfile(widget.id);
    setState(() {});
    print(userProfile.toString());
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: userProfile != null
          ? SafeArea(
            child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap:userProfile?.data?.imageUrl == '' ||
                        userProfile?.data?.imageUrl == null?(){}: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: Stack(
                            children: [InteractiveViewer(
                              child: userProfile?.data?.imageUrl == '' ||
                                  userProfile?.data?.imageUrl == null
                                  ? Image.asset(
                                widget.assetImage,
                              )
                                  : Image.network(userProfile?.data?.imageUrl ?? "",errorBuilder:
                                  (_, __, ___) =>
                                  Image.asset(
                                    widget.assetImage,
                                  ),), // Rasmingizni pathini qo‘shing
                            ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(CupertinoIcons.xmark_circle_fill,color: Colors.white,),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Modal oynani yopish
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
                            image: userProfile?.data?.imageUrl == '' ||
                                userProfile?.data?.imageUrl == null
                                ? AssetImage(
                              userProfile?.data?.gender=="MALE"? widget.assetImage:widget.assetImage,
                            )
                                : NetworkImage(userProfile?.data?.imageUrl ?? "",),
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
                      '${userProfile?.data?.firstName ?? ''} ${userProfile?.data?.lastName ?? ''}',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(
                          color: AppColors.secondary, fontSize: 18.sp),
                    ),
                    10.verticalSpace,
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.location_solid,
                          color: AppColors.secondary,
                        ),
                        5.horizontalSpace,
                        Text(getAddressTranslation(userProfile?.data?.address??'') ??
                            LocaleKeys.Profile_UserProfile_city.tr()),
                        3.horizontalSpace,
                        CircleAvatar(
                          radius: 3,
                          backgroundColor: AppColors.textFieldColor,
                        ),
                        3.horizontalSpace,
                        Text(getNationalityTranslation(userProfile?.data?.nationality??"") ??
                            LocaleKeys.Profile_UserProfile_nationality
                                .tr()),
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
                Text(userProfile?.data?.description ??
                    LocaleKeys.Profile_UserProfile_comment.tr()),
                20.verticalSpace,
                Text(
                  LocaleKeys.UserDetails_mainInfo.tr(),
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                10.verticalSpace,
                DataBox(
                  title: LocaleKeys.UserDetails_age.tr(),
                  text: userProfile?.data?.age != null
                      ? userProfile!.data!.age!.toString()
                      : LocaleKeys.Profile_UserProfile_age.tr(),
                ),
                10.verticalSpace,
                DataBox(
                  title: LocaleKeys.UserDetails_location.tr(),
                  text: getAddressTranslation(userProfile?.data?.address??"") ??
                      LocaleKeys.Profile_UserProfile_address.tr(),
                ),
                10.verticalSpace,
                DataBox(
                  title: LocaleKeys.UserDetails_education.tr(),
                  text: getDegreeTranslation(userProfile?.data?.qualification??"")??
                      LocaleKeys.Profile_UserProfile_education.tr(),
                ),
                10.verticalSpace,
                DataBox(
                  title: LocaleKeys.UserDetails_work.tr(),
                  text: userProfile?.data?.jobTitle ??
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
                        text: userProfile?.data?.status == 'ACTIVE'
                            ? LocaleKeys.UserDetails_activeStatus.tr()
                            : LocaleKeys.UserDetails_inactive.tr(),
                        iconData: CupertinoIcons.plus,
                        onPressed: () {},
                        color: AppColors.golden,
                      ),
                      10.verticalSpace,
                      DataButton(
                        title: LocaleKeys.UserDetails_nationality.tr(),
                        text: getNationalityTranslation(userProfile?.data?.nationality ??"") ??
                            LocaleKeys.Profile_UserProfile_ethnicity.tr(),
                        iconData: CupertinoIcons.plus,
                        onPressed: () {},
                        color: AppColors.green,
                      ),
                      10.verticalSpace,
                      DataButton(
                        title: LocaleKeys.UserDetails_telegram.tr(),
                        text: userProfile?.data?.telegram ??
                            LocaleKeys.Profile_UserProfile_telegram.tr(),
                        iconData: Icons.telegram,
                        onPressed: () async {
                          if (userProfile?.data?.telegram != '' &&
                              userProfile?.data?.telegram != null) {
                            final Uri tg_url = Uri.parse(
                                "https://${userProfile?.data?.telegram ?? ''}");
                            await launchUrl(tg_url,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        color: AppColors.cF79E1B,
                      ),
                      10.verticalSpace,
                      userProfile?.data?.phone != null
                          ? DataButton(
                        title: LocaleKeys.UserDetails_phone.tr(),
                        text: userProfile?.data?.phone ?? '',
                        iconData: CupertinoIcons.phone,
                        onPressed: () async {
                          if (userProfile?.data?.phone != '' &&
                              userProfile?.data?.phone != null) {
                            final Uri tg_url = Uri(
                                scheme: 'tel',
                                path: userProfile?.data?.phone ?? '');
                            await launchUrl(tg_url,
                                mode:
                                LaunchMode.externalApplication);
                          }
                        },
                        color: AppColors.green,
                      )
                          : SizedBox(),
                      10.verticalSpace
                    ],
                  ),
                ),
              ],
            ),
                    ),
                  ),
          )
          : Center(
          child: Platform.isIOS
              ? CupertinoActivityIndicator() // iOS platformasida
              : CircularProgressIndicator()),
    );
  }
}
