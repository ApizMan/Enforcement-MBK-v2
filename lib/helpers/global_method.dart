import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:eo_apk_mbk_v2/resources/resources.dart';

Future<OffenceDataModel> fetchOffenceAreasList({
  void Function(String, double)? onProgress,
}) async {
  final deviceInfo = DeviceInfoPlugin();
  String? deviceId;

  onProgress?.call("Detecting device info...", 0.15);

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor;
  }

  onProgress?.call("Registering handheld...", 0.25);

  final response = await OffenceResources.getDevice(
    prefix: 'RegisterDevice/$deviceId',
  );

  if (response != null && response['HandheldCode'] != null) {
    final handheldCode = response['HandheldCode'];

    await SharedPreferencesHelper.saveHandheldId(handheldCode);

    onProgress?.call("Downloading lookup table...", 0.35);

    final lookupResponse = await OffenceResources.getDownloadLookupTable(
      prefix: 'DownloadLookupTable/$handheldCode',
    );

    List<UserModel> users = [];
    List<OfficerUnitModel> units = [];
    List<VehicleBrandModel> vehicleMakesModel = [];
    List<VehicleModelsModel> vehicleModelsModel = [];
    List<VehicleTypeModel> vehicleTypeModel = [];
    List<VehicleColorModel> vehicleColorModel = [];
    List<OffenceActModel> offenceActModel = [];
    List<OffenceSectionModel> offenceSectionModel = [];
    List<OffenceAreaModel> offenceAreaModel = [];
    List<OffenceLocationModel> offenceLocationModel = [];

    if (lookupResponse != null) {
      if (lookupResponse['OfficerInfos'] is List) {
        onProgress?.call("Loading officer data...", 0.45);
        users = (lookupResponse['OfficerInfos'] as List)
            .map((e) => UserModel.fromJson(e))
            .toList();
      }

      if (lookupResponse['OfficerUnits'] is List) {
        onProgress?.call("Loading unit data...", 0.5);
        units = (lookupResponse['OfficerUnits'] as List)
            .map((e) => OfficerUnitModel.fromJson(e))
            .toList();
      }

      if (lookupResponse['VehicleMakes'] is List) {
        onProgress?.call("Loading vehicle makes...", 0.55);
        vehicleMakesModel = (lookupResponse['VehicleMakes'] as List)
            .map((e) => VehicleBrandModel.fromJson(e))
            .toList();
      }

      if (lookupResponse['VehicleModels'] is List) {
        onProgress?.call("Loading vehicle models...", 0.6);
        vehicleModelsModel = (lookupResponse['VehicleModels'] as List)
            .map((e) => VehicleModelsModel.fromJson(e))
            .toList();
      }

      if (lookupResponse['VehicleTypes'] is List) {
        onProgress?.call("Loading vehicle types...", 0.65);
        vehicleTypeModel = (lookupResponse['VehicleTypes'] as List)
            .map((e) => VehicleTypeModel.fromJson(e))
            .toList();
      }

      if (lookupResponse['VehicleColors'] is List) {
        onProgress?.call("Loading vehicle colors...", 0.7);
        vehicleColorModel = (lookupResponse['VehicleColors'] as List)
            .map((e) => VehicleColorModel.fromJson(e))
            .toList();
      }

      if (lookupResponse['OffenceActs'] is List) {
        onProgress?.call("Loading offence acts...", 0.75);
        offenceActModel = (lookupResponse['OffenceActs'] as List)
            .map((e) => OffenceActModel.fromJson(e))
            .toList();
      }

      if (lookupResponse['OffenceSections'] is List) {
        onProgress?.call("Loading offence sections...", 0.8);
        offenceSectionModel = (lookupResponse['OffenceSections'] as List)
            .map((e) => OffenceSectionModel.fromJson(e))
            .toList();
      }

      if (lookupResponse['OffenceAreas'] is List) {
        onProgress?.call("Loading offence areas...", 0.85);
        offenceAreaModel = (lookupResponse['OffenceAreas'] as List)
            .map((e) => OffenceAreaModel.fromJson(e))
            .toList();
      }

      if (lookupResponse['OffenceLocations'] is List) {
        onProgress?.call("Loading offence locations...", 0.9);
        offenceLocationModel = (lookupResponse['OffenceLocations'] as List)
            .map((e) => OffenceLocationModel.fromJson(e))
            .toList();
      }
    }

    return OffenceDataModel(
      users: users,
      units: units,
      vehicleMakesModel: vehicleMakesModel,
      vehicleModelsModel: vehicleModelsModel,
      vehicleTypeModel: vehicleTypeModel,
      vehicleColorModel: vehicleColorModel,
      offenceActModel: offenceActModel,
      offenceSectionModel: offenceSectionModel,
      offenceAreaModel: offenceAreaModel,
      offenceLocationModel: offenceLocationModel,
    );
  }

  return OffenceDataModel(
    users: [],
    units: [],
    vehicleMakesModel: [],
    vehicleModelsModel: [],
    vehicleTypeModel: [],
    vehicleColorModel: [],
    offenceActModel: [],
    offenceSectionModel: [],
    offenceAreaModel: [],
    offenceLocationModel: [],
  );
}
