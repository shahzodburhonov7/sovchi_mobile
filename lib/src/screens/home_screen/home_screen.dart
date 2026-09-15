import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'package:sovchilar/src/config/core/app_colors.dart';
import 'package:sovchilar/src/config/core/app_icons.dart';
import 'package:sovchilar/src/config/core/app_images.dart';
import 'package:sovchilar/src/screens/profile_page/profile_page.dart';
import 'package:sovchilar/src/screens/subscribed_page/subscribed_page.dart';
import 'package:sovchilar/src/service/socket/socket.dart';
import 'package:sovchilar/translations/locale_keys.g.dart';

import '../../data/login_res.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../service/shared_pref/my_shared_preferences.dart';
import '../chats_page/chats_page.dart';
import '../emptyChat/emptyPage.dart';
import '../questionnaire_page/questionnaire_page.dart';

final scaffoldKey = GlobalKey<_HomeScreenState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void changeLanguage() {
    setState(() {});
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  User? user;
  bool? ok;
  late bool chatOk;

  Future<void> getUser() async {
    final AuthGetUserRepo repo =
    RepositoryProvider.of<AuthGetUserRepo>(context);

    // Avval tokenni yangilaymiz
    await repo.refreshToken();

    // Keyin yangi user + yangi tokenni olamiz
    final String? data =
    await MySharedPreferences.instance.user;

    if (data == null || data.isEmpty) {
      log('❌ USER DATA TOPILMADI');
      return;
    }

    final LoginResponse loginResponse =
    LoginResponse.fromJson(
      jsonDecode(data),
    );

    user = loginResponse.data?.user;

    final String? accessToken =
        loginResponse.data?.tokens?.accessToken;

    if (user?.id == null) {
      log('❌ USER ID TOPILMADI');
      return;
    }

    if (accessToken == null || accessToken.isEmpty) {
      log('❌ ACCESS TOKEN TOPILMADI');
      return;
    }

    log('👤 USER READY: ${user!.id}');

    final socketService = SocketService();

    await socketService.connect(
      user!.id!,
      accessToken,
    );

    log('✅ SOCKET READY IN HOME');

    await repo.paymentCheck();

    ok = await MySharedPreferences.instance.paymentOk;

    chatOk =
        ok == false && user?.gender == "MALE";

    if (mounted) {
      setState(() {});
    }
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> body = [
      QuestionnairePage(),
      SubscribedPage(),
       ChatsPage(),
      ProfilePage(),
    ];

    DateTime? lastPressed;

    Future<bool> onWillPop() async {
      final now = DateTime.now();

      if (lastPressed == null ||
          now.difference(lastPressed!) > const Duration(seconds: 2)) {
        lastPressed = now;
        return false;
      }

      return true;
    }

    final tabs = [
      GlassTab(
        icon: SvgPicture.asset(
          AppIcons.home,
          width: 24.w,
          height: 24.h,
        ),
        activeIcon:
        Image(
          image: AssetImage(
            AppImages.home1,
          ),
          width: 28.w,
          height: 28.h,
        ),
        label: LocaleKeys.Profile_form_home.tr(),
      ),
      GlassTab(
        icon: SvgPicture.asset(
          AppIcons.heart,
          width: 24.w,
          height: 24.h,
        ),
        activeIcon: SvgPicture.asset(
          AppIcons.heart_1,
          width: 24.w,
          height: 24.h,
        ),
        label: LocaleKeys.navbar_favourite.tr(),
      ),
      GlassTab(
        icon: Icon(
          Icons.chat_bubble_outline_rounded,
          size: 24.w,
          color: AppColors.secondary,
        ),
        activeIcon: Icon(
          Icons.chat_bubble_rounded,
          size: 24.w,
          color: AppColors.cA82682,
        ),
        label: LocaleKeys.chat.tr(),
      ),
      GlassTab(
        icon: SvgPicture.asset(
          AppIcons.user,
          width: 24.w,
          height: 24.h,
        ),
        activeIcon: SvgPicture.asset(
          AppIcons.user_1,
          width: 28.w,
          height: 28.h,
        ),
        label: LocaleKeys.profile.tr(),
      ),
    ];

    return WillPopScope(
      onWillPop: onWillPop,
      child: GlassScaffold(
        key: scaffoldKey,
        body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 1,
          itemBuilder: (context, index) {
            return body[_currentIndex];
          },
        ),
        bottomBar: GlassTabBar.bottom(
          tabs: tabs,
          selectedIndex: _currentIndex,
          onTabSelected: (index) {
            _currentIndex = index;
            setState(() {});
          },
          iconSize: 24,

          labelFontSize: 10,
          iconLabelSpacing: 2,
          tabPadding: const EdgeInsets.symmetric(
            horizontal: 2,
          ),
          settings: LiquidGlassSettings(
            glassColor: const Color(0xFFF7F7F7),
            blur: 10,
            thickness: 20,
          ),
          indicatorColor: AppColors.cA82682.withValues(
            alpha: 0.16,
          ),
          selectedLabelColor: AppColors.cA82682,
          unselectedLabelColor: Colors.grey.shade600,
          selectedLabelStyle: const TextStyle(
            decoration: TextDecoration.none,
          ),
          unselectedLabelStyle: const TextStyle(
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

