import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sovchilar/src/config/core/app_icons.dart';

import '../../../config/core/app_colors.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({super.key, required this.onChanged});
  final Function(String) onChanged;
  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final TextEditingController controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: "Qidiruv",
        hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.grey),
        labelStyle: TextStyle(color: AppColors.secondary, fontSize: 16.sp),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixStyle: TextStyle(color: AppColors.secondary, fontSize: 16.sp),
        prefixIcon: Padding(
          padding: EdgeInsets.all(8.w),
          child: SvgPicture.asset(AppIcons.search,height: 16.h,width: 16.w,),
        ),
        counterText: '',
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
