import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:eo_apk_mbk_v2/resources/resources.dart';

Future<OffenceDataModel> fetchOffenceAreasList() async {
  final deviceInfo = DeviceInfoPlugin();
  String? deviceId;

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor;
  }

  if (deviceId == null) {
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

  final response = await OffenceResources.getDevice(
    prefix: 'RegisterDevice/$deviceId',
  );

  if (response != null && response['HandheldCode'] != null) {
    final handheldCode = response['HandheldCode'];

    final lookupResponse = await OffenceResources.getDownloadLookupTable(
      prefix: 'DownloadLookupTable/$handheldCode',
    );

    await SharedPreferencesHelper.saveHandheldId(handheldCode);

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
        users =
            (lookupResponse['OfficerInfos'] as List)
                .map((e) => UserModel.fromJson(e))
                .toList();
      }

      if (lookupResponse['OfficerUnits'] is List) {
        units =
            (lookupResponse['OfficerUnits'] as List)
                .map((e) => OfficerUnitModel.fromJson(e))
                .toList();
      }

      if (lookupResponse['VehicleMakes'] is List) {
        vehicleMakesModel =
            (lookupResponse['VehicleMakes'] as List)
                .map((e) => VehicleBrandModel.fromJson(e))
                .toList();
      }

      if (lookupResponse['VehicleModels'] is List) {
        vehicleModelsModel =
            (lookupResponse['VehicleModels'] as List)
                .map((e) => VehicleModelsModel.fromJson(e))
                .toList();
      }

      if (lookupResponse['VehicleTypes'] is List) {
        vehicleTypeModel =
            (lookupResponse['VehicleTypes'] as List)
                .map((e) => VehicleTypeModel.fromJson(e))
                .toList();
      }

      if (lookupResponse['VehicleColors'] is List) {
        vehicleColorModel =
            (lookupResponse['VehicleColors'] as List)
                .map((e) => VehicleColorModel.fromJson(e))
                .toList();
      }

      if (lookupResponse['OffenceActs'] is List) {
        offenceActModel =
            (lookupResponse['OffenceActs'] as List)
                .map((e) => OffenceActModel.fromJson(e))
                .toList();
      }

      if (lookupResponse['OffenceSections'] is List) {
        offenceSectionModel =
            (lookupResponse['OffenceSections'] as List)
                .map((e) => OffenceSectionModel.fromJson(e))
                .toList();
      }

      if (lookupResponse['OffenceAreas'] is List) {
        offenceAreaModel =
            (lookupResponse['OffenceAreas'] as List)
                .map((e) => OffenceAreaModel.fromJson(e))
                .toList();
      }

      if (lookupResponse['OffenceLocations'] is List) {
        offenceLocationModel =
            (lookupResponse['OffenceLocations'] as List)
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
