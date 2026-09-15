import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/core/app_colors.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Faqat raqamlarni olamiz
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // +998 bu yerda TextField prefix'i bo'lgani uchun faqat 9 ta raqam
    if (digits.length > 9) {
      digits = digits.substring(0, 9);
    }

    String formatted = '';

    if (digits.isNotEmpty) {
      formatted += digits.substring(
        0,
        digits.length >= 2 ? 2 : digits.length,
      );
    }

    if (digits.length > 2) {
      formatted += ' ';
      formatted += digits.substring(
        2,
        digits.length >= 5 ? 5 : digits.length,
      );
    }

    if (digits.length > 5) {
      formatted += ' ';
      formatted += digits.substring(
        5,
        digits.length >= 7 ? 7 : digits.length,
      );
    }

    if (digits.length > 7) {
      formatted += ' ';
      formatted += digits.substring(7);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: formatted.length,
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    this.minLines = 1,
    this.maxLines = 1,
    this.min = false,
    this.onChanged,
    this.onSubmited,
    this.text = '',
    this.helper,
    this.maxLength,
    this.inputFormatter,
    this.password = false,
    this.textInputAction,
    this.keyboardType = TextInputType.name,
    this.hintText = '',
    this.prefixText = '',
    this.regPage = false,
    this.title,
  });

  final TextInputAction? textInputAction;
  final int minLines;
  final int maxLines;
  final bool min;
  final bool password;
  String text;
  final String hintText;
  final String prefixText;
  final String? title;
  final Widget? helper;
  final bool regPage;
  dynamic onChanged;
  dynamic onSubmited;
  TextInputType keyboardType;
  int? maxLength;
  List<TextInputFormatter>? inputFormatter;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController controller = TextEditingController();

  bool passwordShow = true;

  @override
  void initState() {
    super.initState();

    controller.text = widget.text;
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.text != controller.text) {
      controller.value = TextEditingValue(
        text: widget.text,
        selection: TextSelection.collapsed(
          offset: widget.text.length,
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) Text(widget.title!),
        if (widget.title != null) 5.verticalSpace,

        SizedBox(
          width: widget.min ? 140.w : 300.w,
          child: TextField(
            controller: controller,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmited,
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: 16.sp,
            ),
            minLines: widget.minLines,
            maxLines: widget.maxLines,

            // Telefon uchun maxLengthni formatter nazorat qiladi
            maxLength: widget.regPage ? null : widget.maxLength,

            keyboardType: widget.keyboardType,

            inputFormatters: [
              if (widget.regPage)
                PhoneNumberFormatter(),

              if (widget.inputFormatter != null)
                ...widget.inputFormatter!,
            ],

            textInputAction: widget.textInputAction,
            obscureText: widget.password ? passwordShow : false,

            decoration: InputDecoration(
              hintText: widget.hintText,
              helper: widget.helper,

              prefixText: widget.prefixText,

              // +998 90 123 45 67
              labelText: widget.regPage
                  ? '+998 90 123 45 67'
                  : null,

              labelStyle: TextStyle(
                color: AppColors.secondary,
                fontSize: 16.sp,
              ),

              floatingLabelBehavior: FloatingLabelBehavior.never,

              prefixStyle: TextStyle(
                color: AppColors.secondary,
                fontSize: 16.sp,
              ),

              suffixIcon: widget.password
                  ? passwordShow
                  ? IconButton(
                onPressed: () {
                  passwordShow = false;
                  setState(() {});
                },
                icon: const Icon(
                  CupertinoIcons.eye_slash,
                ),
              )
                  : IconButton(
                onPressed: () {
                  passwordShow = true;
                  setState(() {});
                },
                icon: const Icon(
                  CupertinoIcons.eye,
                ),
              )
                  : null,

              hintStyle: widget.regPage
                  ? TextStyle(
                color: AppColors.secondary,
                fontSize: 16.sp,
              )
                  : Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color: AppColors.grey,
              ),

              counterText: '',

              contentPadding: EdgeInsets.symmetric(
                horizontal: 18.w,
                vertical: 13.h,
              ),

              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.textFieldColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),

              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.red.withOpacity(0.5),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),

              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.red,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}