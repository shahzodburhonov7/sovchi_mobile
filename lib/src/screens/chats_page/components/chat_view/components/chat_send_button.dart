import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sovchilar/src/config/core/app_colors.dart';
import 'package:sovchilar/src/config/core/app_images.dart';

class ChatSendButton extends StatelessWidget {
  const ChatSendButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.w,
      height: 50.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Center(
          child: Image(
            image: AssetImage(AppImages.send,),
            width: 24.w,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
