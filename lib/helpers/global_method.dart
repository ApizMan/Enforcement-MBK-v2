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
    prefix: '/compound/register/$deviceId',
  );

  if (response != null && response['handheldCode'] != null) {
    final handheldCode = response['handheldCode'];

    await SharedPreferencesHelper.saveHandheldId(handheldCode);

    onProgress?.call("Downloading lookup table...", 0.35);

    final actResponse = await DownloadLookupResources.getArea(
      prefix: '/list/act',
    );

    final sectionResponse = await DownloadLookupResources.getSection(
      prefix: '/list/section',
    );

    final areaResponse = await DownloadLookupResources.getArea(
      prefix: '/list/area',
    );

    final locationResponse = await DownloadLookupResources.getLocation(
      prefix: '/list/location',
    );

    final officerInfoResponse = await DownloadLookupResources.getOfficerInfo(
      prefix: '/list/officer-info',
    );

    final officerUnitResponse = await DownloadLookupResources.getOfficerUnit(
      prefix: '/list/officer-unit',
    );

    final vehicleMakeResponse = await DownloadLookupResources.getVehicleMake(
      prefix: '/list/vehicle-make',
    );

    final vehicleModelResponse = await DownloadLookupResources.getVehicleModel(
      prefix: '/list/vehicle-model',
    );

    final vehicleTypeResponse = await DownloadLookupResources.getVehicleType(
      prefix: '/list/vehicle-type',
    );

    final vehicleColorResponse = await DownloadLookupResources.getVehicleColor(
      prefix: '/list/vehicle-color',
    );

    await DownloadLookupResources.getGroupMaster(
      prefix: '/list/group-master',
    );

    await DownloadLookupResources.getTicketMaster(
      prefix: '/list/compound',
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

    if (officerInfoResponse['filteredUsers'] is List) {
      onProgress?.call("Loading officer data...", 0.45);
      users = (officerInfoResponse['filteredUsers'] as List)
          .map((e) => UserModel.fromJson(e))
          .toList();
    }

    if (officerUnitResponse['mysqlData'] is List) {
      onProgress?.call("Loading unit data...", 0.5);
      units = (officerUnitResponse['mysqlData'] as List)
          .map((e) => OfficerUnitModel.fromJson(e))
          .toList();
    }

    if (vehicleMakeResponse['data'] is List) {
      onProgress?.call("Loading vehicle makes...", 0.55);
      vehicleMakesModel = (vehicleMakeResponse['data'] as List)
          .map((e) => VehicleBrandModel.fromJson(e))
          .toList();
    }

    if (vehicleModelResponse['mysqlData'] is List) {
      onProgress?.call("Loading vehicle models...", 0.6);
      vehicleModelsModel = (vehicleModelResponse['mysqlData'] as List)
          .map((e) => VehicleModelsModel.fromJson(e))
          .toList();
    }

    if (vehicleTypeResponse['data'] is List) {
      onProgress?.call("Loading vehicle types...", 0.65);
      vehicleTypeModel = (vehicleTypeResponse['data'] as List)
          .map((e) => VehicleTypeModel.fromJson(e))
          .toList();
    }

    if (vehicleColorResponse['data'] is List) {
      onProgress?.call("Loading vehicle colors...", 0.7);
      vehicleColorModel = (vehicleColorResponse['data'] as List)
          .map((e) => VehicleColorModel.fromJson(e))
          .toList();
    }

    if (actResponse['data'] is List) {
      onProgress?.call("Loading offence acts...", 0.75);
      offenceActModel = (actResponse['data'] as List)
          .map((e) => OffenceActModel.fromJson(e))
          .toList();
    }

    if (sectionResponse['data'] is List) {
      onProgress?.call("Loading offence sections...", 0.8);
      offenceSectionModel = (sectionResponse['data'] as List)
          .map((e) => OffenceSectionModel.fromJson(e))
          .toList();
    }

    if (areaResponse['data'] is List) {
      onProgress?.call("Loading offence areas...", 0.85);
      offenceAreaModel = (areaResponse['data'] as List)
          .map((e) => OffenceAreaModel.fromJson(e))
          .toList();
    }

    if (locationResponse['data'] is List) {
      onProgress?.call("Loading offence locations...", 0.9);
      offenceLocationModel = (locationResponse['data'] as List)
          .map((e) => OffenceLocationModel.fromJson(e))
          .toList();
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
