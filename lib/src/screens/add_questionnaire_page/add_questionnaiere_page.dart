import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sovchilar/src/config/core/app_images.dart';
import 'package:sovchilar/src/config/routes/route_names.dart';
import 'package:sovchilar/src/data/get_photo_date.dart';
import 'package:sovchilar/src/data/login_res.dart';
import 'package:sovchilar/translations/locale_keys.g.dart';

import '../../config/core/app_colors.dart';
import '../../data/all_data.dart';
import '../../data/profile_user.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../service/shared_pref/my_shared_preferences.dart';
import '../auth_page/auth_page.dart';
import '../auth_page/component/text_fild.dart';
import '../questionnaire_page/component/app_button.dart';
import '../reg_questionnaire_page/reg_questionnaire_page.dart';
import 'component/terms.dart';

class UserProfileForm extends StatefulWidget {
  const UserProfileForm({super.key});

  @override
  State<UserProfileForm> createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  String? selectedGender;
  final List<String> genders = ['FEMALE', 'MALE'];
  String selectedCity = 'BARCHA SHAHARLAR';
  String selectedMartialStatus = 'ALL';
  String selectedEducation = 'all';
  String selectedNation = 'ALL';
  bool termsDone = false;
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
  final List<String> education = [
    "all",
    "middle",
    "specialized",
    "incompleteHigher",
    "higher",
    "master",
    "doctorate",
  ];
  final List<String> nation = [
    "ALL",
    "Uzbek",
    "Russian",
    "Kazakh",
    "Kyrgyz",
    "Tajik",
    "Turkmen",
    "Tatar",
    "Karakalpak",
    "Other",
  ];
  File? _image;
  PhotoData? photoData;
  User? user;
  bool isButtonEnabled = true;

  final ImagePicker _picker = ImagePicker();

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
      await Permission.camera.request();
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final AuthGetUserRepo repo =
        RepositoryProvider.of<AuthGetUserRepo>(context);
    await requestPermissions();
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      return;
    }
    if (_image != null) {
      photoData = await repo.postPhoto(_image!);
      if (photoData?.data?.path != null || photoData?.data?.path != '') {
        user?.imageUrl = photoData!.data!.path!;
      }
    }

    setState(() {});
  }

  Future<void> getUser() async {
    final AuthGetUserRepo repo =
        RepositoryProvider.of<AuthGetUserRepo>(context);
    String? data = await MySharedPreferences.instance.user;
    LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(data!));
    user = loginResponse.data!.user;
    UserProfile? userProfile = await repo.getUserProfile(user!.id!);
    if (userProfile?.data?.password != null) {
      user?.password = userProfile?.data?.password!;
    }
    setState(() {});
    if (user?.gender != null && user?.gender != '') {
      selectedGender = user?.gender;
      setState(() {});
    }
    if (user?.telegram != null && user?.telegram != '') {
      user?.telegram = user?.telegram!.replaceAll('t.me/', '');
      setState(() {});
    }
    if (user?.address != null && user?.address != '') {
      selectedCity = user!.address!;
      setState(() {});
    }
    if (user?.maritalStatus != null && user?.maritalStatus != '') {
      selectedMartialStatus = user!.maritalStatus!;
      setState(() {});
    }
    if (user?.qualification != null && user?.qualification != '') {
      selectedEducation = user!.qualification!;
      setState(() {});
    }
    if (user?.nationality != null && user?.nationality != '') {
      selectedNation = user!.nationality!;
      setState(() {});
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthGetUserRepo repo =
        RepositoryProvider.of<AuthGetUserRepo>(context);
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          body: SafeArea(
            child: user != null
                ? Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 37.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Center(
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: user?.imageUrl == '' ||
                                            user?.imageUrl == null
                                        ? () {}
                                        : () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: Stack(
                                                  children: [
                                                    InteractiveViewer(
                                                      child: Image.network(
                                                        user?.imageUrl ?? "",
                                                        errorBuilder:
                                                            (_, __, ___) =>
                                                                Image.asset(
                                                                  user?.gender=="MALE"? AppImages.male_1:AppImages.female_1,
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
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 160.w,
                                          height: 160.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                spreadRadius: 4,
                                                blurRadius: 10,
                                                offset: Offset(0,
                                                    4), // Pastga tushgan soya effekti
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Rasm yuklanishi bilan progress indicator
                                        CircleAvatar(
                                          radius: 80.w,
                                          backgroundColor: Colors.grey[100],
                                          // Orqa fon
                                          child: ClipOval(
                                            child: user?.imageUrl == '' ||
                                                    user?.imageUrl == null
                                                ? SizedBox(
                                                    width: 160.w,
                                                    height: 160.h,
                                                    child: Image.asset(
                                                      user?.gender=="MALE"? AppImages.male_1:AppImages.female_1,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : Image.network(
                                                    user?.imageUrl ?? "", // URL
                                                    fit: BoxFit.cover,
                                                    width: 160.w,
                                                    height: 160.h,
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) return child;
                                                      return Center(
                                                        child: Platform.isIOS
                                                            ? CupertinoActivityIndicator() // iOS platformasida
                                                            : CircularProgressIndicator(),
                                                      );
                                                    },
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        SizedBox(
                                                      width: 160.w,
                                                      height: 160.h,
                                                      child: Image.asset(
                                                        user?.gender=="MALE"? AppImages.male_1:AppImages.female_1,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: CircleAvatar(
                                      child: IconButton(
                                        onPressed: () async {
                                          await pickImage(ImageSource.gallery);
                                        },
                                        icon: Icon(
                                          CupertinoIcons.camera_fill,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      child: IconButton(
                                        onPressed: () async {
                                          if (user?.imageUrl != '' &&
                                              user?.imageUrl != null) {
                                            bool ok = await repo.delImage(
                                                imageUrl: user!.imageUrl!);
                                            user?.imageUrl = '';
                                            setState(() {});
                                            if (ok) {
                                              await repo.updateImageUrl();
                                            }
                                          }
                                        },
                                        icon: Icon(
                                          CupertinoIcons.xmark_circle_fill,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            15.verticalSpace,
                            CustomTextField(
                              title:
                                  LocaleKeys.auth_FormOne_firstNameLabel.tr(),
                              hintText: LocaleKeys
                                  .auth_CombinedForm_firstNamePlaceholder
                                  .tr(),
                              text: user?.firstName ?? "",
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              onChanged: (String text) {
                                user?.firstName = text;
                                setState(() {});
                                debugPrint(text);
                              },
                            ),
                            15.verticalSpace,
                            CustomTextField(
                              title: LocaleKeys.auth_FormOne_lastNameLabel.tr(),
                              hintText: LocaleKeys
                                  .auth_CombinedForm_lastNamePlaceholder
                                  .tr(),
                              text: user?.lastName ?? "",
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              onChanged: (String text) {
                                user?.lastName = text;
                                setState(() {});
                                debugPrint(text);
                              },
                            ),
                            15.verticalSpace,
                            CustomTextField(
                              title: LocaleKeys.auth_FormOne_telegramLabel.tr(),
                              hintText: "@telegram",
                              text: user?.telegram ?? "",
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              onChanged: (String text) {
                                user?.telegram = text;
                                setState(() {});
                                debugPrint(text);
                              },
                            ),
                            15.verticalSpace,
                            CustomTextField(
                              title: LocaleKeys.auth_FormOne_ageLabel.tr(),
                              hintText:
                                  LocaleKeys.auth_FormOne_agePlaceholder.tr(),
                              text:
                                  user?.age == null ? '' : user!.age.toString(),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              onChanged: (String text) {
                                user?.age = int.tryParse(text);
                                setState(() {});
                                debugPrint(text);
                              },
                            ),
                            15.verticalSpace,
                            Row(
                              children: [
                                Text(LocaleKeys.auth_FormOne_genderLabel.tr()),
                              ],
                            ),
                            5.verticalSpace,
                            SizedBox(
                              width: 300.w,
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
                                  hintText: 'Jinsingizni tanlang',
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
                                value: selectedGender,
                                isExpanded: true,
                                items: genders.map((gender) {
                                  return DropdownMenuItem(
                                    value: gender,
                                    child: Text(
                                      gender != "MALE"
                                          ? LocaleKeys.auth_FormOne_genderFemale
                                              .tr()
                                          : LocaleKeys.auth_FormOne_genderMale
                                              .tr(),
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value;
                                  });
                                },
                              ),
                            ),
                            15.verticalSpace,
                            Row(
                              children: [
                                Text(LocaleKeys
                                    .home_SecondHomePageSearch_form_city_label
                                    .tr())
                              ],
                            ),
                            5.verticalSpace,
                            SizedBox(
                              width: 300.w,
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
                                    selectedCity = value!;
                                  });
                                },
                              ),
                            ),
                            15.verticalSpace,
                            Row(
                              children: [
                                Text(LocaleKeys.auth_FormTwo_education.tr()),
                              ],
                            ),
                            5.verticalSpace,
                            SizedBox(
                              width: 300.w,
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
                                value: selectedEducation,
                                isExpanded: true,
                                items: education.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      getDegreeTranslation(value),
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedEducation = value!;
                                  });
                                },
                              ),
                            ),
                            15.verticalSpace,
                            Row(
                              children: [
                                Text(LocaleKeys.auth_FormTwo_maritalStatus_label
                                    .tr()),
                              ],
                            ),
                            5.verticalSpace,
                            SizedBox(
                              width: 300.w,
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
                                      selectedGender == 'MALE' ||
                                              selectedGender == null
                                          ? getMartialStatusMaleTranslation(
                                              value)
                                          : getMartialStatusFemaleTranslation(
                                              value),
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedMartialStatus = value!;
                                  });
                                },
                              ),
                            ),
                            15.verticalSpace,
                            CustomTextField(
                              title: LocaleKeys.auth_FormTwo_jobTitle.tr(),
                              hintText: LocaleKeys
                                  .auth_FormTwo_jobTitlePlaceholder
                                  .tr(),
                              text: user!.jobTitle ?? "",
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              onChanged: (String text) {
                                user!.jobTitle = text;
                                setState(() {});
                                debugPrint(text);
                              },
                            ),
                            15.verticalSpace,
                            Row(
                              children: [
                                Text(LocaleKeys.auth_FormTwo_nationality.tr()),
                              ],
                            ),
                            5.verticalSpace,
                            SizedBox(
                              width: 300.w,
                              child: DropdownButtonFormField<String>(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.secondary),
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  prefixStyle: TextStyle(
                                      color: AppColors.secondary, fontSize: 18.sp),
                                  counterText: '',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AppColors.grey, fontSize: 18.sp),
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
                                value: selectedNation,
                                isExpanded: true,
                                items: nation.map((gender) {
                                  return DropdownMenuItem(
                                    value: gender,
                                    child: Text(
                                      getNationalityTranslation(gender),
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedNation = value!;
                                  });
                                },
                              ),
                            ),
                            15.verticalSpace,
                            CustomTextField(
                              title: LocaleKeys.auth_FormTwo_aboutYourself.tr(),
                              hintText: LocaleKeys
                                  .auth_FormTwo_aboutYourselfPlaceholder
                                  .tr(),
                              text: user?.description ?? "",
                              minLines: 4,
                              maxLines: 4,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              onChanged: (String text) {
                                user?.description = text;
                                setState(() {});
                                debugPrint(text);
                              },
                            ),
                            registerAddQues?  10.verticalSpace:SizedBox(),
                            registerAddQues?  Row(
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      showTermsDialog(context, onPressed: () {
                                        termsDone = true;
                                        isButtonEnabled = true;
                                        setState(() {});
                                        Navigator.pop(context);
                                      });
                                    },
                                    icon: termsDone
                                        ? Icon(CupertinoIcons
                                            .checkmark_square_fill)
                                        : Icon(CupertinoIcons.square)),
                                Text(LocaleKeys.auth_FormTwo_terms_button_text
                                    .tr()),
                              ],
                            ):SizedBox(),
                            20.verticalSpace,
                            AppButton(
                              color: AppColors.cA82682,
                              text:
                                  LocaleKeys.footer_forUsers_createProfile.tr(),
                              onPressed: isButtonEnabled
                                  ? () async {
                                      isButtonEnabled = false;
                                      setState(() {});
                                      if (selectedGender != null &&
                                          selectedCity != 'BARCHA SHAHARLAR' &&
                                          selectedMartialStatus != 'ALL' &&
                                          selectedEducation != 'all' &&
                                          user!.firstName != '' &&
                                          user!.lastName != '' &&
                                          user!.telegram != '' &&
                                          user!.age != null &&
                                          user!.jobTitle != '' &&
                                          user!.description != '' &&
                                          selectedNation != 'ALL') {
                                        user?.telegram =
                                            't.me/${user?.telegram!}';
                                        user?.nationality = selectedNation;
                                        user?.gender = selectedGender;
                                        user?.qualification = selectedEducation;
                                        user?.address = selectedCity;
                                        user?.maritalStatus =
                                            selectedMartialStatus;
                                        print(registerAddQues);
                                        print(termsDone);
                                        if(registerAddQues&&termsDone){
                                          bool? ok = await repo.updateUser(
                                              updateUser: user!);
                                          if (ok) {
                                            registerAddQues = false;
                                            Navigator.pushNamedAndRemoveUntil(context, RouteNames.home, (_)=>false);
                                          }
                                        } else if(
                                        registerAddQues==false
                                        ){
                                          bool? ok = await repo.updateUser(
                                              updateUser: user!);
                                          if (ok) {
                                            Navigator.pop(context);
                                          }
                                        }

                                      } else {
                                        isButtonEnabled = true;
                                        setState(() {});
                                        String label = LocaleKeys.set_data.tr();

                                        showErrorDialog(
                                            context: context, text: label);
                                      }
                                    }
                                  : () {},
                              width: 300.w,
                            ),
                            20.verticalSpace,
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Platform.isIOS
                        ? CupertinoActivityIndicator()
                        : CircularProgressIndicator(),
                  ),
          ),
        ));
  }
}
