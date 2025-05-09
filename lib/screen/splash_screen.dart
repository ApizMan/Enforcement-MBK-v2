import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/global_method.dart';
import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:eo_apk_mbk_v2/routes/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int activeStepper = 1;
  bool _isInit = false;
  late String handHeldId;
  late OffenceDataModel data;

  @override
  void initState() {
    super.initState();
    _startInitialization();
  }

  Future<void> _startInitialization() async {
    data = await fetchOffenceAreasList(); // ✅ Fetch this first

    await _getUserData(); // ✅ Then get user data
    await requestPermissions(); // ✅ Then request permissions

    _initialize(); // ✅ Then run initialize logic
  }

  Future<void> requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.locationWhenInUse,
      Permission.photos,
      Permission.storage,
    ].request();
  }

  void _initialize() async {
    if (_isInit) return;

    await Future.delayed(const Duration(seconds: 2));

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
            'vehicleTypeModel': data.vehicleTypeModel,
            'vehicleMakesModel': data.vehicleMakesModel,
            'vehicleModelsModel': data.vehicleModelsModel,
            'vehicleColorModel': data.vehicleColorModel,
            'offenceActModel': data.offenceActModel,
            'offenceSectionModel': data.offenceSectionModel,
            'offenceAreaModel': data.offenceAreaModel,
            'offenceLocationModel': data.offenceLocationModel,
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
            'vehicleTypeModel': data.vehicleTypeModel,
            'vehicleMakesModel': data.vehicleMakesModel,
            'vehicleModelsModel': data.vehicleModelsModel,
            'vehicleColorModel': data.vehicleColorModel,
            'offenceActModel': data.offenceActModel,
            'offenceSectionModel': data.offenceSectionModel,
            'offenceAreaModel': data.offenceAreaModel,
            'offenceLocationModel': data.offenceLocationModel,
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
