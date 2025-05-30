import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/theme.dart';
import 'package:flutter/material.dart';

class FooterLayout extends StatelessWidget {
  final String handHeldId;
  const FooterLayout({super.key, required this.handHeldId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      padding: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(color: kPrimaryColor.withOpacity(0.2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(handHeldId, style: textStyleNormal(fontWeight: FontWeight.bold)),
          Text(
            "Version ${versionAPK} powered by CCP",
            style: textStyleNormal(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
