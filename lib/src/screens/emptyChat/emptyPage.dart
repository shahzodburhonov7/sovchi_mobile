import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sovchilar/translations/locale_keys.g.dart';

class Emptypage extends StatelessWidget {
  const Emptypage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                LocaleKeys.premiumOk.tr(),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
