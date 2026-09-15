import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sovchilar/src/config/core/app_colors.dart';
import 'package:sovchilar/src/config/core/app_icons.dart';
import 'package:sovchilar/src/config/core/app_images.dart';
import 'package:sovchilar/src/data/all_data.dart';
import 'package:sovchilar/src/screens/chats_page/components/chat_view/chat_view.dart';
import 'package:sovchilar/src/screens/questionnaire_page/component/app_button.dart';
import 'package:sovchilar/src/screens/user_profile/user_profile_page.dart';
import 'package:sovchilar/src/service/shared_pref/my_shared_preferences.dart';
import 'package:sovchilar/translations/locale_keys.g.dart';

import '../../../data/get_users.dart';
import '../../../domain/network/dio_settings.dart';
import '../../../domain/repositories/auth_repo.dart';
import '../../../service/socket/socket.dart';
import '../../auth_page/auth_page.dart';

class QuestionnaireBox extends StatefulWidget {
  const QuestionnaireBox({
    super.key,
    required this.user,
    this.favorite = false,
    required this.onPressed,
    required this.assetImage,
  });

  final VoidCallback onPressed;
  final Items user;
  final bool favorite;
  final String assetImage;

  @override
  State<QuestionnaireBox> createState() => _QuestionnaireBoxState();
}

class _QuestionnaireBoxState extends State<QuestionnaireBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25.r)),
        border: Border.all(color: AppColors.textFieldColor, width: 1.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.r),
                  topRight: Radius.circular(25.r)),
              image: DecorationImage(
                  image: widget.user.imageUrl == ''
                      ? AssetImage(widget.assetImage)
                      : NetworkImage(widget.user.imageUrl!),
                  alignment: Alignment.center,
                  fit: BoxFit.cover),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: widget.onPressed,
                        splashRadius: 1,
                        icon: SvgPicture.asset(
                          AppIcons.heart_1,
                          color: widget.favorite ? Colors.red : Colors.white,
                          height: 24.h,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.w),
                        decoration: BoxDecoration(
                          color: widget.user.maritalStatus == "SINGLE"
                              ? AppColors.green.withOpacity(0.5)
                              : AppColors.golden.withOpacity(0.5),
                          borderRadius: BorderRadius.all(Radius.circular(15.r)),
                        ),
                        child: Text(
                          widget.user.gender == "MALE"
                              ? getMartialStatusMaleTranslation(
                                  widget.user.maritalStatus ?? "")
                              : getMartialStatusFemaleTranslation(
                                  widget.user.maritalStatus ?? ""),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${widget.user.firstName ?? ""} ${widget.user.age ?? ""}",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(color: Colors.white, shadows: [
                            Shadow(
                                color: Colors.black,
                                blurRadius: 25,
                                offset: Offset(0, 0))
                          ])),
                      5.verticalSpace,
                      Row(
                        children: [
                          Icon(CupertinoIcons.location_solid,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                    color: Colors.black,
                                    blurRadius: 25,
                                    offset: Offset(0, 0))
                              ]),
                          Text(getAddressTranslation(widget.user.address ?? ""),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white, shadows: [
                                Shadow(
                                    color: Colors.black,
                                    blurRadius: 25,
                                    offset: Offset(0, 0))
                              ])),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          15.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${LocaleKeys.userCard_nationality.tr()}: ${getNationalityTranslation(widget.user.nationality ?? "") ?? ""}',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyLarge),
                3.verticalSpace,
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: AppColors.profileGrey.withOpacity(0.3),
                ),
                10.verticalSpace,
                Text(
                    '${LocaleKeys.userCard_education.tr()}: ${getDegreeTranslation(widget.user.qualification ?? "") ?? ""}',
                    style: Theme.of(context).textTheme.bodyLarge),
                3.verticalSpace,
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: AppColors.profileGrey.withOpacity(0.3),
                ),
                10.verticalSpace,
                Text(
                    '${LocaleKeys.userCard_description.tr()} ${widget.user.description ?? ""}',
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyLarge),
                3.verticalSpace,
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: AppColors.profileGrey.withOpacity(0.3),
                ),
                25.verticalSpace,
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppButton(
                color: AppColors.cA82682,
                text: LocaleKeys.userCard_moreDetails.tr(),
                onPressed: () async {
                  bool ok = await MySharedPreferences.instance.paymentOk;
                  if (ok) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => MultiRepositoryProvider(
                          providers: [
                            RepositoryProvider(
                              create: (context) => DioSettings(),
                            ),
                            RepositoryProvider(
                              create: (context) => AuthGetUserRepo(
                                  dio: RepositoryProvider.of<DioSettings>(
                                          context)
                                      .dio),
                            ),
                          ],
                          child: UserProfilePage(
                            id: widget.user.id!,
                            assetImage: widget.assetImage,
                          ),
                        ),
                      ),
                    );
                  } else {
                    showErrorDialog(
                      context: context,
                      text: LocaleKeys.premiumOk.tr(),
                    );
                  }
                },
                width: 120.w,
                height: 40.h,
                borderRadius: 15,
              ),
              AppButton(
                color: AppColors.cA82682,
                text: LocaleKeys.chat.tr(),
                onPressed: () async {
                  final socketService = SocketService();

                  final consId = await socketService.createConversation(
                    widget.user.id!,
                  );

                  if (consId == null || consId.isEmpty) {
                    log('❌ CONVERSATION ID OLINGMADI');
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiRepositoryProvider(
                        providers: [
                          RepositoryProvider(
                            create: (_) => DioSettings(),
                          ),
                          RepositoryProvider(
                            create: (context) => AuthGetUserRepo(
                              dio: RepositoryProvider.of<DioSettings>(context).dio,
                            ),
                          ),
                        ],
                        child: ChatView(
                          consId: consId,
                          userName: widget.user.firstName!,
                          userId: widget.user.id!,
                        ),
                      ),
                    ),
                  );
                },
                width: 120.w,
                height: 40.h,
                borderRadius: 15,
              ),
            ],
          ),
          20.verticalSpace
        ],
      ),
    );
  }
}
