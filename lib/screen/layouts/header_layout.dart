import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HeaderLayout extends StatelessWidget implements PreferredSizeWidget {
  const HeaderLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      excludeHeaderSemantics: true,
      backgroundColor: accentCanvasColor,
      foregroundColor: kWhite,
      title: Text(
        AppLocalizations.of(context)!.handHeldMBK,
        style: textStyleNormal(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: kWhite,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
