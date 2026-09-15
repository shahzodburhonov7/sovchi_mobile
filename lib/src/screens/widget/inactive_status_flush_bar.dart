import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sovchilar/src/config/core/app_colors.dart';

class InactiveStatusFlushBar {

  static void show(BuildContext context,
  { required String title,
    required String message,}
      ) {
    Flushbar(
      margin: EdgeInsets.all(16.w),
      borderRadius: BorderRadius.circular(18.r),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 14.h,
      ),
      backgroundColor: AppColors.cA82682.withOpacity(0.65),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: const Duration(seconds: 3),

      boxShadows: [
        BoxShadow(
          color: AppColors.cA82682.withOpacity(0.20),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],

      icon: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.info_outline_rounded,
          color: Colors.white,
          size: 22.w,
        ),
      ),

      titleText: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
        ),
      ),

      messageText: Text(
        message,
        style: TextStyle(
          color: Colors.white.withOpacity(0.85),
          fontSize: 13.sp,
        ),
      ),
    ).show(context);
  }
}