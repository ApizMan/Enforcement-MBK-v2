import 'package:eo_apk_mbk_v2/models/models.dart';

class OffenceDataModel {
  final List<UserModel> users;
  final List<OfficerUnitModel> units;
  final List<VehicleBrandModel> vehicleMakesModel;
  final List<VehicleModelsModel> vehicleModelsModel;
  final List<VehicleTypeModel> vehicleTypeModel;
  final List<VehicleColorModel> vehicleColorModel;

  OffenceDataModel({
    required this.users,
    required this.units,
    required this.vehicleMakesModel,
    required this.vehicleModelsModel,
    required this.vehicleTypeModel,
    required this.vehicleColorModel,
  });
}
