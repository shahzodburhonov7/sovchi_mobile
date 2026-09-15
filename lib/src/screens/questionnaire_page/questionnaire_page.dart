import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sovchilar/src/config/core/app_colors.dart';
import 'package:sovchilar/src/config/core/app_icons.dart';
import 'package:sovchilar/src/config/core/app_images.dart';
import 'package:sovchilar/src/data/all_data.dart';
import 'package:sovchilar/src/data/get_users.dart';
import 'package:sovchilar/src/screens/auth_page/component/text_fild.dart';
import 'package:sovchilar/src/screens/questionnaire_page/component/app_button.dart';
import 'package:sovchilar/src/service/shared_pref/my_shared_preferences.dart';
import 'package:sovchilar/translations/locale_keys.g.dart';

import '../../data/favorite_users.dart';
import '../../data/login_res.dart';
import '../../domain/repositories/auth_repo.dart';
import 'component/questionnaire_box.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage>
    with AutomaticKeepAliveClientMixin {
  String minAge = '18';
  String maxAge = '90';
  String selectedCity = 'BARCHA SHAHARLAR';
  String selectedMartialStatus = 'ALL';
  String searchGender = '';
  int page = 1;
  final List<String> cities = [
    'BARCHA SHAHARLAR',
    'TOSHKENT',
    'ANDIJON',
    'BUXORO',
    'FARGONA',
    'JIZZAX',
    'XORAZM',
    'NAMANGAN',
    'NAVOIY',
    'QASHQADARYO',
    'SAMARQAND',
    'SIRDARYO',
    'SURXONDARYO',
    'QORAQALPOGISTON',
  ];
  final List<String> maritalStatus = [
    "ALL",
    'SINGLE',
    'DIVORCED',
    'MARRIED_SECOND',
  ];

  List<Items> users = [];

  Future<void> getUsers({
    int ageFrom = 18,
    int ageTo = 30,
    String? address,
    String? maritalStatus,
    int page1 = 1,
    bool search = false
  }) async {
    await getGender();

    final AuthGetUserRepo repo =
        RepositoryProvider.of<AuthGetUserRepo>(context);
    final GetUsers? getUsers = await repo.getUsers(
      gender: searchGender == "MALE" ? "FEMALE" : "MALE",
      ageFrom: ageFrom,
      ageTo: ageTo,
      address: address,
      maritalStatus: maritalStatus,
      page: page1,
    );
    if(search) users = [];
    if (getUsers != null) {
        for (Items user in getUsers.data!.items!) {
          if(users.contains(user)!=true){
            user.gender == 'MALE'
    ?user.assetImage = getMaleRandomImages()
        :user.assetImage = getFemaleRandomImages();
            users.add(user);
          }
        }
    }
    setState(() {});
  }

  List<String> favoriteUsersIdList = [];

  Future<void> getFavoriteUsersString() async {
    final AuthGetUserRepo repo =
        RepositoryProvider.of<AuthGetUserRepo>(context);
    final FavoriteUsers favoriteUsers = await repo.getFavoriteUsers();
    favoriteUsers.data?.forEach((value) {
      if (favoriteUsersIdList.contains(value.favourite!.id) != true) {
        favoriteUsersIdList.add(value.favourite!.id ?? "");
      }
    });
    setState(() {});
  }

  Future<void> getGender() async {
    User? user;
    String? data = await MySharedPreferences.instance.user;
    LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(data!));
    user = loginResponse.data?.user;
    searchGender = user?.gender ?? "";
  }

  @override
  void initState() {
    getGender();
    getFavoriteUsersString();
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final AuthGetUserRepo repo =
        RepositoryProvider.of<AuthGetUserRepo>(context);
    return Scaffold(

      appBar: AppBar(

          scrolledUnderElevation: 0,
          leading: Row(
            children: [
              30.horizontalSpace,
              Image(
                image: AssetImage(AppImages.logo),
                width: 100.w,
              ),
            ],
          ),
          centerTitle: true,
          leadingWidth: 130.w,
          actions: [
            AppButton(
              color: AppColors.cA82682,
              text: LocaleKeys.home_SecondHomePageSearch_form_search.tr(),
              hasIcon: true,
              iconName: AppIcons.search,
              height: 40.h,
              width: 100.w,
              borderRadius: 15.r,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder:
                        (BuildContext context, StateSetter setModalState) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              LocaleKeys
                                  .home_SecondHomePageSearch_form_age_label
                                  .tr(),
                              textAlign: TextAlign.start,
                            ),
                            10.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomTextField(
                                  min: true,
                                  text: minAge,
                                  maxLength: 2,
                                  keyboardType: TextInputType.number,
                                  onChanged: (String text) {
                                    setModalState(() {
                                      minAge = text;
                                    });
                                  },
                                ),
                                10.horizontalSpace,
                                Text("-"),
                                10.horizontalSpace,
                                CustomTextField(
                                    min: true,
                                    text: maxAge,
                                    onChanged: (String text) {
                                      setModalState(() {
                                        maxAge = text;
                                      });
                                    },
                                    maxLength: 2,
                                    keyboardType: TextInputType.number),
                              ],
                            ),
                            10.verticalSpace,
                            Text(
                              LocaleKeys
                                  .home_SecondHomePageSearch_form_city_label
                                  .tr(),
                            ),
                            10.verticalSpace,
                            SizedBox(
                              width: 330.w,
                              child: DropdownButtonFormField<String>(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.secondary),
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  prefixStyle: TextStyle(
                                      color: AppColors.secondary, fontSize: 16.sp),
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AppColors.grey, fontSize: 16.sp),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 18.w, vertical: 12.h),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.textFieldColor,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.textFieldColor
                                            .withOpacity(0.5),
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.textFieldColor,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                value: selectedCity,
                                isExpanded: true,
                                items: cities.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      getAddressTranslation(value),
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCity = value ?? selectedCity;
                                  });
                                },
                              ),
                            ),
                            10.verticalSpace,
                            Text(
                              LocaleKeys
                                  .home_SecondHomePageSearch_form_maritalStatus_label
                                  .tr(),
                            ),
                            10.verticalSpace,
                            SizedBox(
                              child: DropdownButtonFormField<String>(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.secondary),
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  prefixStyle: TextStyle(
                                      color: AppColors.secondary, fontSize: 16.sp),
                                  counterText: '',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AppColors.grey, fontSize: 16.sp),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 18.w, vertical: 12.h),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.textFieldColor,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.textFieldColor
                                            .withOpacity(0.5),
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.textFieldColor,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                value: selectedMartialStatus,
                                isExpanded: true,
                                items: maritalStatus.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      searchGender == "MALE"
                                          ? getMartialStatusFemaleTranslation(
                                                  value) ??
                                              ""
                                          : getMartialStatusMaleTranslation(
                                                  value) ??
                                              "",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedMartialStatus =
                                        value ?? selectedMartialStatus;
                                  });
                                },
                              ),
                            ),
                            10.verticalSpace,
                            Text(
                              LocaleKeys
                                  .home_SecondHomePageSearch_form_gender_label
                                  .tr(),
                            ),
                            10.verticalSpace,
                            AppButton(
                              color: AppColors.cA82682,
                              text: searchGender != "MALE"
                                  ? LocaleKeys.auth_CombinedForm_genderMale.tr()
                                  : LocaleKeys.auth_CombinedForm_genderFemale
                                      .tr(),
                              onPressed: () {},
                              width: 340.w,
                              borderRadius: 15,
                            ),
                            20.verticalSpace,
                            AppButton(
                              color: AppColors.primary,
                              text: LocaleKeys
                                  .home_SecondHomePageSearch_form_search
                                  .tr(),
                              onPressed: () async {
                                await getUsers(
                                  search: true,
                                  ageTo: int.tryParse(maxAge) ?? 30,
                                  ageFrom: int.tryParse(minAge) ?? 18,
                                  address: selectedCity == "BARCHA SHAHARLAR"
                                      ? null
                                      : selectedCity,
                                  maritalStatus: selectedMartialStatus == "ALL"
                                      ? null
                                      : selectedMartialStatus,
                                );
                                Navigator.pop(context);
                              },
                              width: 340.w,
                              borderRadius: 15,
                            ),
                            30.verticalSpace,
                          ],
                        ),
                      );
                    });
                  },
                );
              },
            ),
            30.horizontalSpace,
          ]),
      body: users.isEmpty
          ? Center(
              child: Platform.isIOS
                  ? CupertinoActivityIndicator() // iOS platformasida
                  : CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          users.isNotEmpty ? users.length + 1 : users.length,
                      key: PageStorageKey<String>('my_list_view'),
                      itemBuilder: (BuildContext context, int index) {
                        if (index == users.length) {
                          return Column(
                            children: [
                              AppButton(
                                width: 310.w,
                                color: AppColors.cA82682,
                                borderRadius: 15.r,
                                text: LocaleKeys
                                    .home_SecondHomePageSearch_ShowMore
                                    .tr(),
                                onPressed: () async {
                                  page =page+1;
                                  setState(() {});
                                  await getUsers(
                                    ageTo: int.tryParse(maxAge) ?? 30,
                                    ageFrom: int.tryParse(minAge) ?? 18,
                                    address: selectedCity == "BARCHA SHAHARLAR"
                                        ? null
                                        : selectedCity,
                                    maritalStatus:
                                        selectedMartialStatus == "ALL"
                                            ? null
                                            : selectedMartialStatus,
                                    page1: page
                                  );
                                },
                              ),
                              10.verticalSpace,
                            ],
                          );
                        }
                        return QuestionnaireBox(
                          user: users[index],
                          favorite:
                              favoriteUsersIdList.contains(users[index].id!),
                          onPressed: () async {
                            await repo.setFavorite(users[index].id!);
                            if (favoriteUsersIdList
                                .contains(users[index].id!)) {
                              favoriteUsersIdList.remove(users[index].id!);
                            }
                            getFavoriteUsersString();
                            setState(() {});
                          },
                          assetImage: users[index].assetImage!
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
