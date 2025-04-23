import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/theme.dart';
import 'package:flutter/material.dart';

class HeaderLayout extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const HeaderLayout({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      excludeHeaderSemantics: true,
      backgroundColor: accentCanvasColor,
      foregroundColor: kWhite,
      title: Text(
        title,
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
