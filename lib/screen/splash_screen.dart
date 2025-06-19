// ignore_for_file: deprecated_member_use

import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/global_method.dart';
import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:eo_apk_mbk_v2/routes/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  double progress = 0.0;
  String loadingMessage = "Initializing...";

  @override
  void initState() {
    super.initState();
    _startInitialization();
    _resetCompoundAndImage();
  }

  Future<void> _resetCompoundAndImage() async {
    final prefs = await SharedPreferences.getInstance();

    // ✅ Get the list from SharedPreferences
    final List<String>? pendingList =
        prefs.getStringList(officerCompoundModelPendingKey);

    // ✅ Only clear if the list is not null (has something)
    if (pendingList != null) {
      await SharedPreferencesHelper
          .clearOldOfficerCompoundModelsPendingIfNotToday();
    }

    // ✅ Always clear the confirmed compound models
    await SharedPreferencesHelper.clearOldOfficerCompoundModelsIfNotToday();
  }

  Future<void> _startInitialization() async {
    setState(() {
      loadingMessage = "Fetching offence data...";
      progress = 0.1;
    });

    data = await fetchWithRetry(context, onProgress: _updateProgress);

    setState(() {
      loadingMessage = "Reading user credentials...";
      progress = 0.95;
    });
    await _getUserData();

    setState(() {
      loadingMessage = "Requesting permissions...";
      progress = 0.98;
    });
    await requestPermissions();

    _initialize();
  }

  Future<OffenceDataModel> fetchWithRetry(
    BuildContext context, {
    required void Function(String, double)? onProgress,
  }) async {
    final data = await fetchOffenceAreasList(onProgress: onProgress);

    final isEmpty = data.users.isEmpty &&
        data.units.isEmpty &&
        data.vehicleMakesModel.isEmpty;

    if (isEmpty) {
      final retry = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Connection Error"),
          content: const Text(
              "❌ Gagal memuat turun data daripada server.\nCuba lagi?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Cuba Lagi"),
            ),
          ],
        ),
      );

      if (retry == true) {
        return await fetchWithRetry(context, onProgress: onProgress);
      }
    }

    return data;
  }

  void _updateProgress(String message, double percent) {
    setState(() {
      loadingMessage = message;
      progress = percent;
    });
  }

  Future<void> requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.locationWhenInUse,
      Permission.photos,
      Permission.storage,
      Permission.manageExternalStorage,
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(), // Top spacer
          Center(
            child: Image.asset(
              logo,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballSpinFadeLoader,
                    colors: [
                      kPrimaryColor,
                      kPrimaryColor.withOpacity(0.5),
                      kBlack
                    ],
                    backgroundColor: kBackgroundColor,
                    pathBackgroundColor: kBackgroundColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  loadingMessage,
                  style: const TextStyle(color: kBlack, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "${(progress * 100).toInt()}%",
                  style: const TextStyle(color: kBlack, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
