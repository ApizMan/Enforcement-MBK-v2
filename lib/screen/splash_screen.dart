import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/global_method.dart';
import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:eo_apk_mbk_v2/routes/route_manager.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int activeStepper = 1;
  bool _isInit = false;
  late String handHeldId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initialize();
  }

  @override
  void initState() {
    handHeldId = "";
    super.initState();
    _getUserData();
  }

  void _initialize() async {
    if (_isInit) return;

    await Future.delayed(const Duration(seconds: 2));

    final OffenceDataModel data = await fetchOffenceAreasList();

    final userLogin = await SharedPreferencesHelper.getLoginCredential();

    if (mounted) {
      if (userLogin['id'] != null && userLogin['password'] != null) {
        Navigator.pushReplacementNamed(
          context,
          RouteManager.homeScreen,
          arguments: {
            'userModel': data.users,
            'unitModel': data.units,
            'handHeldId': handHeldId,
          },
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          RouteManager.loginScreen,
          arguments: {
            'userModel': data.users,
            'unitModel': data.units,
            'handHeldId': handHeldId,
          },
        );
      }
    }

    _isInit = true;
  }

  Future<void> _getUserData() async {
    handHeldId = await SharedPreferencesHelper.getHandheldId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(logo),
          ),
        ],
      ),
    );
  }
}
