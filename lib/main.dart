import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:sovchilar/src/bloc/chat_view_bloc/chat_view_bloc.dart';
import 'package:sovchilar/src/config/routes/app_routes.dart';
import 'package:sovchilar/src/config/routes/route_names.dart';
import 'package:sovchilar/src/config/theme/app_theme.dart';
import 'package:sovchilar/src/service/shared_pref/my_shared_preferences.dart';
import 'package:sovchilar/src/service/socket/socket.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();

  await EasyLocalization.ensureInitialized();
  await MySharedPreferences.instance.initPref();
  checkProfile();
  runApp(LiquidGlassWidgets.wrap(
    child: EasyLocalization(
        supportedLocales: [Locale('uz'), Locale('ru')],
        path: 'assets/locale',
        child: BlocProvider(
            create: (BuildContext context) => ChatViewBloc(SocketService()),
            child: const MyApp())),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    checkProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.black,
              systemNavigationBarIconBrightness: Brightness.light),
        );
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: lightTheme,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: child!,
          ),
          navigatorKey: rootNavigatorKey,
          initialRoute: RouteNames.init,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      },
    );
  }
}
