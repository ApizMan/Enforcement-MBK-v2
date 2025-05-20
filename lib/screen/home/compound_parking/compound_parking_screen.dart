// ignore_for_file: non_constant_identifier_names

import 'package:eo_apk_mbk_v2/form_blocs/form_bloc.dart';
import 'package:eo_apk_mbk_v2/screen/screen.dart';
import 'package:flutter/material.dart';

class CompoundParkingScreen extends StatefulWidget {
  final VehicleValidationFormBloc? vehicleValidationFormBloc;
  final CompoundParkingFormBloc? compoundParkingFormBloc;
  const CompoundParkingScreen({
    super.key,
    this.vehicleValidationFormBloc,
    this.compoundParkingFormBloc,
  });

  @override
  State<CompoundParkingScreen> createState() => _CompoundParkingScreenState();
}

class _CompoundParkingScreenState extends State<CompoundParkingScreen> {
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
      compoundParkingFormBloc: widget.compoundParkingFormBloc,
      vehicleValidationFormBloc: widget.vehicleValidationFormBloc,
    );
  }

  Widget ActFault(BuildContext context) {
    return ActFaultScreen(
      compoundParkingFormBloc: widget.compoundParkingFormBloc,
      vehicleValidationFormBloc: widget.vehicleValidationFormBloc,
    );
  }

  Widget SummaryFault(BuildContext context) {
    return SummaryFaultScreen(
      compoundParkingFormBloc: widget.compoundParkingFormBloc,
      vehicleValidationFormBloc: widget.vehicleValidationFormBloc,
    );
  }
}
