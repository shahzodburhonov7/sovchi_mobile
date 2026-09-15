import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sovchilar/src/config/core/app_colors.dart';

class DataButton extends StatelessWidget {
  const DataButton(
      {super.key,
      required this.title,
      required this.text,
      required this.iconData,
      required this.onPressed,
      required this.color});

  final String title;
  final String text;
  final Color color;
  final IconData iconData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.r))),
      padding: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      onPressed: onPressed,
      child: Container(
        height: 60.h,
        width: 300.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textFieldColor),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          children: [
            20.horizontalSpace,
            Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                border: Border.all(color: AppColors.textFieldColor),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Icon(
                iconData,
              ),
            ),
            20.horizontalSpace,
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  Text(text),
                ],
              ),
            ),
            30.horizontalSpace,
          ],
        ),
      ),
    );
  }
}
