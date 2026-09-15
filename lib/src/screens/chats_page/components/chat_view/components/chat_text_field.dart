import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/core/app_colors.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: "Massage",
        hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.grey),
        labelStyle: TextStyle(color: AppColors.secondary, fontSize: 16.sp),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixStyle: TextStyle(color: AppColors.secondary, fontSize: 16.sp),
        counterText: '',
        fillColor: Colors.white,
        filled: true,
        contentPadding:
        EdgeInsets.symmetric(horizontal: 18.w, vertical: 13.h),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: AppColors.textFieldColor, width: 1.5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.red .withOpacity(0.5),
              width: 1.5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
              color: AppColors.red, width: 1.5),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),

    );
  }
}
