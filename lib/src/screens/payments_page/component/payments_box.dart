import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sovchilar/src/config/core/app_colors.dart';
import 'package:sovchilar/src/screens/questionnaire_page/component/app_button.dart';

class PaymentsBox extends StatelessWidget {
  const PaymentsBox(
      {super.key,
      required this.title,
      required this.price,
      required this.m1,
      required this.m2,
      required this.m3,
      required this.m4,
      required this.m5, required this.onPressed});

  final String title;
  final String price;
  final String m1;
  final String m2;
  final String m3;
  final String m4;
  final String m5;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 291.h,
      width: 350.w,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.r)),
          border: Border.all(
            color: AppColors.divColor,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: Colors.deepPurpleAccent),
            ),
          ),
          Center(
            child: Text(
              price,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: AppColors.secondary),
            ),
          ),
          10.verticalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                m1,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.secondary),
              ),
              Text(
                m2,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.secondary),
              ),
              Text(
                m3,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.secondary),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                m4,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.secondary),
              ),
              Text(
                m5,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.secondary),
              ),
            ],
          ),
          20.verticalSpace,
          AppButton(
              color: AppColors.divColor,
              text: "Payme",
              img: true,
              onPressed: onPressed)
        ],
      ),
    );
  }
}
