import 'package:eo_apk_mbk_v2/models/models.dart';

class OffenceDataModel {
  final List<UserModel> users;
  final List<OfficerUnitModel> units;
  final List<VehicleBrandModel> vehicleMakesModel;
  final List<VehicleModelsModel> vehicleModelsModel;
  final List<VehicleTypeModel> vehicleTypeModel;
  final List<VehicleColorModel> vehicleColorModel;
  final List<OffenceActModel> offenceActModel;
  final List<OffenceSectionModel> offenceSectionModel;
  final List<OffenceAreaModel> offenceAreaModel;
  final List<OffenceLocationModel> offenceLocationModel;

  OffenceDataModel({
    required this.users,
    required this.units,
    required this.vehicleMakesModel,
    required this.vehicleModelsModel,
    required this.vehicleTypeModel,
    required this.vehicleColorModel,
    required this.offenceActModel,
    required this.offenceSectionModel,
    required this.offenceAreaModel,
    required this.offenceLocationModel,
  });
}
