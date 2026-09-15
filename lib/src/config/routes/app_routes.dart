import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sovchilar/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:sovchilar/src/bloc/chat_bloc/chat_bloc.dart';
import 'package:sovchilar/src/config/routes/route_names.dart';
import 'package:sovchilar/src/domain/network/dio_settings.dart';
import 'package:sovchilar/src/domain/repositories/auth_repo.dart';
import 'package:sovchilar/src/screens/add_questionnaire_page/add_questionnaiere_page.dart';
import 'package:sovchilar/src/screens/auth_page/auth_page.dart';
import 'package:sovchilar/src/screens/forget_pass_page/forget_pass_page.dart';
import 'package:sovchilar/src/screens/home_screen/home_screen.dart';
import 'package:sovchilar/src/screens/new_pass_page/new_pass_page.dart';
import 'package:sovchilar/src/screens/otp_screen/otp_page.dart';
import 'package:sovchilar/src/screens/payments_page/payments_page.dart';
import 'package:sovchilar/src/screens/reg_page/reg_page.dart';
import 'package:sovchilar/src/screens/reg_questionnaire_page/reg_questionnaire_page.dart';

import '../../service/shared_pref/my_shared_preferences.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

bool _hasProfile = false;

Future<void> checkProfile() async {
  _hasProfile = await MySharedPreferences.instance.hasProfile;
}

sealed class AppRoutes {
  AppRoutes._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (kDebugMode) {}
    switch (settings.name) {
      case RouteNames.init:
        if (_hasProfile) {
          return CupertinoPageRoute(
            builder: (_) => MultiRepositoryProvider(
              providers: [
                RepositoryProvider(
                  create: (context) => DioSettings(),
                ),
                RepositoryProvider(
                  create: (context) => AuthGetUserRepo(
                      dio: RepositoryProvider.of<DioSettings>(context).dio),
                ),
              ],
              child: BlocProvider(
                create: (context) => ChatBloc(),
                child: HomeScreen(),
              ),
            ),
          );
        } else {
          return MaterialPageRoute(
            builder: (_) => MultiRepositoryProvider(providers: [
              RepositoryProvider(
                create: (context) => DioSettings(),
              ),
              RepositoryProvider(
                create: (context) => AuthGetUserRepo(
                    dio: RepositoryProvider.of<DioSettings>(context).dio),
              ),
            ], child: const AuthPage()),
          );
        }
      case RouteNames.home:
        return CupertinoPageRoute(
            builder: (_) => MultiRepositoryProvider(
                    providers: [
                      RepositoryProvider(
                        create: (context) => DioSettings(),
                      ),
                      RepositoryProvider(
                        create: (context) => AuthGetUserRepo(
                            dio: RepositoryProvider.of<DioSettings>(context)
                                .dio),
                      ),
                    ],
                    child: BlocProvider(
                      create: (context) => ChatBloc(),
                      child: HomeScreen(),
                    )));
      case RouteNames.auth:
        return CupertinoPageRoute(
            builder: (_) => MultiRepositoryProvider(
                  providers: [
                    RepositoryProvider(
                      create: (context) => DioSettings(),
                    ),
                    RepositoryProvider(
                      create: (context) => AuthGetUserRepo(
                          dio: RepositoryProvider.of<DioSettings>(context).dio),
                    ),
                  ],
                  child: BlocProvider(
                      create: (BuildContext context) => AuthBloc(),
                      child: const AuthPage()),
                ));
      case RouteNames.addForm:
        return CupertinoPageRoute(
            builder: (_) => MultiRepositoryProvider(
                  providers: [
                    RepositoryProvider(
                      create: (context) => DioSettings(),
                    ),
                    RepositoryProvider(
                      create: (context) => AuthGetUserRepo(
                          dio: RepositoryProvider.of<DioSettings>(context).dio),
                    ),
                  ],
                  child: UserProfileForm(),
                ));
      case RouteNames.forgetPass:
        return CupertinoPageRoute(
            builder: (_) => MultiRepositoryProvider(providers: [
                  RepositoryProvider(
                    create: (context) => DioSettings(),
                  ),
                  RepositoryProvider(
                    create: (context) => AuthGetUserRepo(
                        dio: RepositoryProvider.of<DioSettings>(context).dio),
                  ),
                ], child: const ForgetPassPage()));
      case RouteNames.regPage:
        return CupertinoPageRoute(
            builder: (_) => MultiRepositoryProvider(providers: [
                  RepositoryProvider(
                    create: (context) => DioSettings(),
                  ),
                  RepositoryProvider(
                    create: (context) => AuthGetUserRepo(
                        dio: RepositoryProvider.of<DioSettings>(context).dio),
                  ),
                ], child: const RegPage()));
      // case RouteNames.otp:
      //   return CupertinoPageRoute(
      //       builder: (_) => MultiRepositoryProvider(providers: [
      //             RepositoryProvider(
      //               create: (context) => DioSettings(),
      //             ),
      //             RepositoryProvider(
      //               create: (context) => AuthGetUserRepo(
      //                   dio: RepositoryProvider.of<DioSettings>(context).dio),
      //             ),
      //           ], child: const OtpPage()));
      //
        case RouteNames.regQues:
        return CupertinoPageRoute(
            builder: (_) => MultiRepositoryProvider(providers: [
                  RepositoryProvider(
                    create: (context) => DioSettings(),
                  ),
                  RepositoryProvider(
                    create: (context) => AuthGetUserRepo(
                        dio: RepositoryProvider.of<DioSettings>(context).dio),
                  ),
                ], child: const RegQuestionnairePage()));
      case RouteNames.payment:
        return CupertinoPageRoute(
            builder: (_) => MultiRepositoryProvider(providers: [
                  RepositoryProvider(
                    create: (context) => DioSettings(),
                  ),
                  RepositoryProvider(
                    create: (context) => AuthGetUserRepo(
                        dio: RepositoryProvider.of<DioSettings>(context).dio),
                  ),
                ], child: const PaymentsPage()));
      case RouteNames.newPass:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => MultiRepositoryProvider(
            providers: [
              RepositoryProvider(
                create: (context) => DioSettings(),
              ),
              RepositoryProvider(
                create: (context) => AuthGetUserRepo(
                  dio: RepositoryProvider.of<DioSettings>(context).dio,
                ),
              ),
            ],
            child: const NewPassPage(),
          ),
        );
      default:
        return CupertinoPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text("route : ${settings.name}"),
            ),
          ),
        );
    }
  }
}
