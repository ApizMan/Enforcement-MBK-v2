// ignore_for_file: deprecated_member_use

import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/theme.dart';
import 'package:eo_apk_mbk_v2/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingBodyScreen extends StatelessWidget {
  final String handHeldId;
  final Map<String, dynamic> userData;
  final Map<String, dynamic> printerMAC;
  const SettingBodyScreen({
    super.key,
    required this.handHeldId,
    required this.userData,
    required this.printerMAC,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 30,
          width: double.infinity,
          decoration: BoxDecoration(
            color: accentCanvasColor.withOpacity(0.5),
            border: Border.all(color: accentCanvasColor),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Status",
              style: textStyleNormal(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: kWhite,
              border: Border.all(color: accentCanvasColor),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.unit,
                          style: textStyleNormal(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.handheldId,
                          style: textStyleNormal(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(child: Text(userData['unit'] ?? '')),
                      Expanded(child: Text(handHeldId)),
                    ],
                  ),
                  spaceVertical(height: 10.0),
                  Text(
                    AppLocalizations.of(context)!.idLogIn,
                    style: textStyleNormal(fontWeight: FontWeight.bold),
                  ),
                  Text('${userData['id']} - ${userData['name']}'),
                  spaceVertical(height: 10.0),
                  Text(
                    AppLocalizations.of(context)!.totalAllNotice,
                    style: textStyleNormal(fontWeight: FontWeight.bold),
                  ),
                  Text('0'),
                  spaceVertical(height: 10.0),
                  Text(
                    AppLocalizations.of(context)!.totalNoticeNotYetUpload,
                    style: textStyleNormal(fontWeight: FontWeight.bold),
                  ),
                  Text('0'),
                  spaceVertical(height: 10.0),
                  Text(
                    AppLocalizations.of(context)!.totalPicture,
                    style: textStyleNormal(fontWeight: FontWeight.bold),
                  ),
                  Text('0'),
                  spaceVertical(height: 10.0),
                  Text(
                    AppLocalizations.of(context)!.totalPayTransaction,
                    style: textStyleNormal(fontWeight: FontWeight.bold),
                  ),
                  Text('0'),
                  spaceVertical(height: 10.0),
                  Text(
                    AppLocalizations.of(context)!.totalAmountPayment,
                    style: textStyleNormal(fontWeight: FontWeight.bold),
                  ),
                  Text('RM 0.00'),
                ],
              ),
            ),
          ),
        ),
        PrinterFunction(
          printerMAC: printerMAC,
          handHeldId: handHeldId,
          userData: userData,
        ),
        spaceVertical(height: 20.0),
      ],
    );
  }
}
