import 'package:flutter/material.dart';

// Link
const String baseUrl =
    'http://myenforcement-mbk-staging.vista-summerose.com/VistaParkingWebService/HandheldService.svc/';

const String trafficManagementUrl =
    'https://traffic-management.vista-summerose.com/api/traffic-management/';

const String enYasinUrl =
    'https://mycouncil.citycarpark.my/parking/ctcp/services-listerner_mbk.php';

const String myEnfocementEnYasinUrl =
    'http://myenforce.citycarpark.my/HandheldApi_MBK/HandheldService.svc/JSONService/';

const String backendUrl = 'http://220.158.208.216:3030';

const String pahangGoUrl = 'https://staging.forcify.xyz/api/v1/external/';

// Colors
const Color kBlack = Colors.black;
const Color kWhite = Colors.white;
const Color kPrimaryColor = Color.fromRGBO(34, 74, 151, 1);
const Color kSecondaryColor = Color.fromRGBO(134, 156, 255, 1);
const Color kBackgroundColor = Color.fromARGB(255, 249, 246, 246);
const Color kGrey = Colors.grey;
const Color kOrange = Colors.orange;
const Color kYellow = Colors.yellow;
const Color kRed = Color.fromARGB(255, 240, 108, 99);
const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);

// image
const String logo = 'assets/images/logo.png';

// Shared Preference Key
const String handHeldIdKey = 'handHeldIdKey';
const String loginIdKey = 'loginIdKey';
const String loginNameKey = 'loginNameKey';
const String loginPasswordKey = 'loginPasswordKey';
const String loginUnitKey = 'loginUnitKey';
const String loginWitnessKey = 'loginWitnessKey';
const String isPrinterNewKey = 'isPrinterNewKey';
const String printerMACKey = 'printerMACKey';
const String isMACSaveKey = 'isMACSaveKey';
const String tokenTMKey = 'tokenTMKey';
const String serialNumberKey = 'serialNumberKey';
const String serialDateKey = 'notice_serial_date';
const String captureImageCompoundKey = 'captureImageCompoundKey';
const String captureImageCompoundPendingKey = 'captureImageCompoundPendingKey';
const String btnCheckPushKey = 'btnCheckPushKey';
const String officerCompoundModelPendingKey = 'officerCompoundModelPendingKey';
const String officerCompoundModelKey = 'officerCompoundModelKey';
const String verifyDescKey = 'verifyDescKey';
const String imageCountKey = 'imageCountKey';
const String compoundIdKey = 'compoundIdKey';

final divider = Divider(color: kWhite.withOpacity(0.3), height: 1);

class DialogType {
  static const int info = 1;
  static const int danger = 2;
  static const int warning = 3;
  static const int success = 4;
}

// Success
const kBgSuccess = Colors.green;
const kTextSuccess = Color.fromRGBO(236, 253, 245, 1.0);

// Danger
const kBgDanger = Color.fromRGBO(153, 27, 27, 1.0);
const kTextDanger = Color.fromRGBO(254, 242, 242, 1.0);

// Warning
const kBgWarning = Color.fromRGBO(188, 139, 20, 6);
const kTextWarning = Color.fromRGBO(255, 251, 235, 1.0);

// Info
const kBgInfo = kPrimaryColor;
const kTextInfo = Color.fromRGBO(236, 253, 245, 1.0);

const double hasBottomAppBarSize = 48;
const double noBottomAppBarSize = 10;

const String versionAPK = '1.0.0';
