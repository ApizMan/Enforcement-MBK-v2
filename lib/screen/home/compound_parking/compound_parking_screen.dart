// ignore_for_file: non_constant_identifier_names

import 'package:eo_apk_mbk_v2/form_blocs/form_bloc.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:eo_apk_mbk_v2/screen/screen.dart';
import 'package:flutter/material.dart';

class CompoundParkingScreen extends StatelessWidget {
  final VehicleValidationFormBloc? vehicleValidationFormBloc;
  final CompoundParkingFormBloc? compoundParkingFormBloc;
  final List<UserModel>? userModel;
  final List<OfficerUnitModel>? unitModel;
  final String? handHeldId;
  final List<VehicleTypeModel>? vehicleTypeModel;
  final List<VehicleBrandModel>? vehicleMakesModel;
  final List<VehicleModelsModel>? vehicleModelsModel;
  final List<VehicleColorModel>? vehicleColorModel;
  final List<OffenceActModel>? offenceActModel;
  final List<OffenceSectionModel>? offenceSectionModel;
  final List<OffenceAreaModel>? offenceAreaModel;
  final List<OffenceLocationModel>? offenceLocationModel;
  const CompoundParkingScreen({
    super.key,
    this.vehicleValidationFormBloc,
    this.compoundParkingFormBloc,
    this.unitModel,
    this.userModel,
    this.handHeldId,
    this.offenceActModel,
    this.offenceAreaModel,
    this.offenceLocationModel,
    this.offenceSectionModel,
    this.vehicleColorModel,
    this.vehicleMakesModel,
    this.vehicleModelsModel,
    this.vehicleTypeModel,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        VehicleFault(context),
        ActFault(context),
        SummaryFault(context),
      ],
    );
  }

  Widget VehicleFault(BuildContext context) {
    return VehicleFaultScreen(
      compoundParkingFormBloc: compoundParkingFormBloc,
      vehicleValidationFormBloc: vehicleValidationFormBloc,
      userModel: userModel!,
      unitModel: unitModel!,
      handHeldId: handHeldId!,
      offenceActModel: offenceActModel!,
      offenceAreaModel: offenceAreaModel!,
      offenceLocationModel: offenceLocationModel!,
      offenceSectionModel: offenceSectionModel!,
      vehicleColorModel: vehicleColorModel!,
      vehicleMakesModel: vehicleMakesModel!,
      vehicleModelsModel: vehicleModelsModel!,
      vehicleTypeModel: vehicleTypeModel!,
    );
  }

  Widget ActFault(BuildContext context) {
    return ActFaultScreen(
      compoundParkingFormBloc: compoundParkingFormBloc,
      vehicleValidationFormBloc: vehicleValidationFormBloc,
      userModel: userModel!,
      unitModel: unitModel!,
      handHeldId: handHeldId!,
      offenceActModel: offenceActModel!,
      offenceAreaModel: offenceAreaModel!,
      offenceLocationModel: offenceLocationModel!,
      offenceSectionModel: offenceSectionModel!,
      vehicleColorModel: vehicleColorModel!,
      vehicleMakesModel: vehicleMakesModel!,
      vehicleModelsModel: vehicleModelsModel!,
      vehicleTypeModel: vehicleTypeModel!,
    );
  }

  Widget SummaryFault(BuildContext context) {
    return SummaryFaultScreen(
      compoundParkingFormBloc: compoundParkingFormBloc,
      vehicleValidationFormBloc: vehicleValidationFormBloc,
    );
  }
}
