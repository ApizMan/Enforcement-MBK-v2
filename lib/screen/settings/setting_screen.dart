import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:eo_apk_mbk_v2/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isInitialized = false;
  List<UserModel> userModel = []; // Initialize this
  List<OfficerUnitModel> unitModel = []; // Initialize this
  late String handHeldId;
  late Map<String, dynamic> userData;
  late Map<String, dynamic> printerMAC;

  @override
  void initState() {
    handHeldId = "";
    printerMAC = {};
    userData = {};
    super.initState();
    _getUserData();
    _getPrinterMAC();
  }

  Future<void> _getUserData() async {
    final data = await SharedPreferencesHelper.getLoginCredential();
    setState(() {
      userData = {
        'id': data['id'] ?? '',
        'name': data['name'] ?? '',
        'password': data['password'] ?? '',
        'unit': data['unit'] ?? '',
        'witness': data['witness'] ?? '',
      };
    });
  }

  Future<void> _getPrinterMAC() async {
    final data = await SharedPreferencesHelper.getPrinterMAC();
    setState(() {
      printerMAC = {
        'printerMAC': data['printerMAC'] ?? '',
        'isMACSave': data['isMACSave'] ?? false,
      };
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      handHeldId = arguments?['handHeldId'] as String;
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: HeaderLayout(title: AppLocalizations.of(context)!.setting),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SettingBodyScreen(
          handHeldId: handHeldId,
          userData: userData,
          printerMAC: printerMAC,
        ),
      ),
    );
  }
}
