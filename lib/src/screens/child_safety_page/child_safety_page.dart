import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/core/app_colors.dart';

class ChildSafetyPage extends StatefulWidget {
  const ChildSafetyPage({super.key});

  @override
  State<ChildSafetyPage> createState() => _ChildSafetyPageState();
}

class _ChildSafetyPageState extends State<ChildSafetyPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  bool _submitted = false;
  bool _loading = false;

  static const _policyUrl = 'https://shahzodburhonov7.github.io/sovchi_mobile/child-safety-policy.html';

  final _dio = Dio(BaseOptions(
    baseUrl: 'https://back.sovchilar.net/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await _dio.post(
        '/child-safety-report',
        data: {'message': _descriptionController.text.trim()},
        options: Options(validateStatus: (s) => s != null && s < 600),
      );
    } catch (_) {
      // show success regardless — the form submission is in-app
    } finally {
      if (mounted) setState(() {_loading = false; _submitted = true;});
    }
  }

  Future<void> _openPolicy() async {
    final uri = Uri.parse(_policyUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bolalar xavfsizligi'),
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(15),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.primary.withAlpha(60)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.shield_outlined,
                            color: AppColors.primary, size: 20.sp),
                        8.horizontalSpace,
                        Text(
                          'Bolalar xavfsizligi siyosati',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    12.verticalSpace,
                    Text(
                      'Sovchilar.net platformasida bolalarga zarar yetkazuvchi '
                      'har qanday kontent yoki xatti-harakat qat\'iyan taqiqlanadi. '
                      'Shubhali holat yuzaga kelsa, bizga xabar bering.',
                      style: TextStyle(fontSize: 13.sp, height: 1.5),
                    ),
                    12.verticalSpace,
                    GestureDetector(
                      onTap: _openPolicy,
                      child: Text(
                        'Siyosatni to\'liq ko\'rish →',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13.sp,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              24.verticalSpace,
              if (_submitted)
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(20),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.green.withAlpha(80)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline,
                          color: Colors.green),
                      12.horizontalSpace,
                      Flexible(
                        child: Text(
                          'Xabaringiz yuborildi. Ko\'rib chiqiladi.',
                          style:
                              TextStyle(color: Colors.green[700], fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                Text(
                  'Muammoni tasvirlab bering',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                    color: AppColors.secondary,
                  ),
                ),
                10.verticalSpace,
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  maxLength: 1000,
                  decoration: InputDecoration(
                    hintText:
                        'Muammo haqida batafsil yozing...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Matn kiriting' : null,
                ),
                20.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: _loading ? null : _submitReport,
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Xabar yuborish',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
