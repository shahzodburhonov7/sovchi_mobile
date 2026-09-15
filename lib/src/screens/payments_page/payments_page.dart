import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sovchilar/src/config/core/app_colors.dart';
import 'package:sovchilar/src/data/payment_url.dart';
import 'package:sovchilar/src/screens/payments_page/component/payments_box.dart';
import 'package:sovchilar/translations/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/payment_plans.dart';
import '../../domain/repositories/auth_repo.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  PaymentPlans? paymentPlans;

  bool langRu = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getPlans();
  }

  Future<void> getPlans() async {
    final AuthGetUserRepo repo =
    RepositoryProvider.of<AuthGetUserRepo>(context);

    try {
      final result = await repo.getPaymentPlans();

      if (!mounted) return;

      setState(() {
        paymentPlans = result;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('GET PAYMENT PLANS ERROR: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pay(int index) async {
    if (paymentPlans?.data == null ||
        index >= paymentPlans!.data!.length) {
      return;
    }

    final AuthGetUserRepo repo =
    RepositoryProvider.of<AuthGetUserRepo>(context);

    final paymentUrl = await repo.paymentUrl(
      planId: paymentPlans!.data![index].id!,
    );

    final url = paymentUrl?.data?.paymentUrl;

    if (url == null || url.isEmpty) {
      return;
    }

    final Uri payUrl = Uri.parse(url);

    if (await canLaunchUrl(payUrl)) {
      await launchUrl(
        payUrl,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    langRu = context.locale == const Locale('ru');

    // API hali javob bermagan
    if (isLoading || paymentPlans == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.secondary,
            ),
          ),
        ),
      );
    }

    // API kelgan, lekin planlar yo'q
    final plans = paymentPlans!.data ?? [];

    if (plans.isEmpty) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Text(
              'Tariflar mavjud emas',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),
          ),
        ),
      );
    }

    final AuthGetUserRepo repo =
    RepositoryProvider.of<AuthGetUserRepo>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    LocaleKeys.aloqaPrem.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(
                      color: AppColors.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  20.verticalSpace,

                  ...plans.map(
                        (plan) {
                      final name = langRu
                          ? plan.name?.ru
                          : plan.name?.uz;

                      final benefits = plan.benefits ?? [];

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: 20.h,
                        ),
                        child: PaymentsBox(
                          title: name ?? '',
                          price: '${plan.price ?? ''} UZS',

                          m1: benefits.length > 0
                              ? (langRu
                              ? benefits[0].ru ?? ''
                              : benefits[0].uz ?? '')
                              : '',

                          m2: benefits.length > 1
                              ? (langRu
                              ? benefits[1].ru ?? ''
                              : benefits[1].uz ?? '')
                              : '',

                          m3: benefits.length > 2
                              ? (langRu
                              ? benefits[2].ru ?? ''
                              : benefits[2].uz ?? '')
                              : '',

                          m4: benefits.length > 3
                              ? (langRu
                              ? benefits[3].ru ?? ''
                              : benefits[3].uz ?? '')
                              : '',

                          m5: benefits.length > 4
                              ? (langRu
                              ? benefits[4].ru ?? ''
                              : benefits[4].uz ?? '')
                              : '',

                          onPressed: () async {
                            final index = plans.indexOf(plan);

                            if (index == -1) return;

                            await _pay(index);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}