// ignore_for_file: use_build_context_synchronously

import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    builder: (_) => LoadingDialog(key: key),
  ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);
  // this is for loading indicator
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(12.0),
            child: LoadingIndicator(
              indicatorType: Indicator.ballRotateChase,
              // ignore: deprecated_member_use
              colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.5), kWhite],
              backgroundColor: kBackgroundColor,
              pathBackgroundColor: kBackgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
