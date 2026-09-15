import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sovchilar/src/config/core/app_images.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {super.key,
      required this.color,
      required this.text,
      this.hasBorder = false,
      this.height = 50,
      this.width,
      this.textColor = Colors.white,
      this.borderColor = Colors.red,
      this.hasDiv = false,
      this.hasIcon = false,
      this.iconName,
      required this.onPressed,
      this.borderRadius = 8,
      this.titleText, this.img = false});

  final Color color;
  final String text;
  final Color textColor;
  final double height;
  final double? width;
  final bool hasBorder;
  final VoidCallback onPressed;
  final Color borderColor;
  final bool hasDiv;
  final bool hasIcon;
  final bool img;
  final String? iconName;
  final String? titleText;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 300.w,
      height: height.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: hasBorder ? Colors.white : color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
            side: hasBorder
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            hasIcon
                ? SvgPicture.asset(
                    iconName!,
                    color: Colors.white,
                    height: 24.h,
                    width: 24.w,
                  )
                : SizedBox(),
            hasIcon ? 5.horizontalSpace : SizedBox(),
            !img
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      titleText != null
                          ? Text(
                              titleText ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                    color: textColor,
                                    fontSize: 14.sp,
                                  ),
                            )
                          : SizedBox(),
                      Text(
                        text,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: textColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                : Image(image: AssetImage(AppImages.payme)),
          ],
        ),
      ),
    );
  }
}
