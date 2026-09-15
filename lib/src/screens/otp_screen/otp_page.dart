// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sovchilar/src/config/routes/app_routes.dart';
// import 'package:sovchilar/src/config/routes/route_names.dart';
// import 'package:sovchilar/src/screens/forget_pass_page/forget_pass_page.dart';
// import 'package:sovchilar/translations/locale_keys.g.dart';
//
// import '../../config/core/app_colors.dart';
// import '../../domain/repositories/auth_repo.dart';
// import '../auth_page/component/text_fild.dart';
// import '../questionnaire_page/component/app_button.dart';
// import '../reg_page/reg_page.dart';
//
// class OtpPage extends StatefulWidget {
//   const OtpPage({super.key});
//
//   @override
//   State<OtpPage> createState() => _OtpPageState();
// }
// String newPassLogin ='';
// class _OtpPageState extends State<OtpPage> {
//   String code = '';
//   String rgData = forgetLogin.length>3?forgetLogin:regData;
//
//   @override
//   Widget build(BuildContext context) {
//     final AuthGetUserRepo repo =
//     RepositoryProvider.of<AuthGetUserRepo>(context);
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).requestFocus(new FocusNode());
//       },
//       child: Scaffold(
//         body: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 20.w),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   LocaleKeys.register_title_smsCode.tr(),
//                   style: Theme.of(context)
//                       .textTheme
//                       .displayLarge
//                       ?.copyWith(color: AppColors.secondary),
//                   textAlign: TextAlign.center,
//                 ),
//                 40.verticalSpace,
//                 CustomTextField(
//                   hintText: LocaleKeys.register_placeholders_codeText.tr(),
//                   maxLength: 6,
//                   text: code,
//                   textInputAction: TextInputAction.done,
//                   keyboardType: TextInputType.number,
//                   onChanged: (String text) {
//                     code = text;
//                     debugPrint(text);
//                   },
//                 ),
//                 20.verticalSpace,
//                 AppButton(
//                   color: AppColors.cA82682,
//                   text: LocaleKeys.register_button_confirmation.tr(),
//                   onPressed: () async{
//                     if(rgData == forgetLogin){
//                       if(rgData.contains('+')){
//                         bool ok = await repo.verifyPhoneWithCode(phone: rgData, code: code);
//                         if(ok){
//                           newPassLogin = rgData;
//                           Navigator.pushReplacementNamed(context, RouteNames.newPass);
//                         }
//                       }else{
//                         bool ok = await repo.verifyEmailWithCode(email: rgData, code: code);
//                         if(ok){
//                           newPassLogin = rgData;
//                           Navigator.pushReplacementNamed(context, RouteNames.newPass);
//                         }
//                       }
//                     }else if(rgData == regData){
//                       if(rgData.contains('+')){
//                         bool ok = await repo.verifyPhoneWithCode(phone: rgData, code: code);
//                         if(ok){
//                           Navigator.pushReplacementNamed(context, RouteNames.regQues);
//                         }
//                       }else{
//                         bool ok = await repo.verifyEmailWithCode(email: rgData, code: code);
//                         if(ok){
//                           Navigator.pushReplacementNamed(context, RouteNames.regQues);
//                         }
//                       }
//                     }
//                   },
//                   width: 300.w,
//                 ),
//                 10.verticalSpace,
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(LocaleKeys.register_link_text.tr()),
//                     5.horizontalSpace,
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushNamedAndRemoveUntil(
//                             context, RouteNames.auth, (route) => false);
//                       },
//                       child: Text(LocaleKeys.login_title.tr()),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
