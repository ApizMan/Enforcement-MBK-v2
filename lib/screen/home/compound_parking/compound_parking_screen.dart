// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'package:eo_apk_mbk_v2/form_blocs/form_bloc.dart';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/theme.dart';
import 'package:eo_apk_mbk_v2/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompoundParkingScreen extends StatelessWidget {
  final VehicleValidationFormBloc? vehicleValidationFormBloc;
  final CompoundParkingFormBloc? compoundParkingFormBloc;
  const CompoundParkingScreen({
    super.key,
    this.vehicleValidationFormBloc,
    this.compoundParkingFormBloc,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [VehicleFault(context), ActFault(), SummaryFault()],
    );
  }

  Widget VehicleFault(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              // PLate Number field
              Expanded(
                child: TextFieldBlocBuilder(
                  textFieldBloc: vehicleValidationFormBloc!.plateNumber,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.plateNumber),
                    prefixIcon: const Icon(Icons.abc_rounded),
                    hintText:
                        '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.idUser}',
                    hintStyle: const TextStyle(color: Colors.black26),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: kBlack),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: kBlack),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
              // Verify button
              spaceHorizontal(width: 10.0),
              PrimaryButton(
                buttonWidth: 0.3,
                borderRadius: 10.0,
                onPressed: () => vehicleValidationFormBloc!.submit(),
                label: Text(
                  AppLocalizations.of(context)!.verify,
                  style: textStyleNormal(color: kWhite),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget SummaryFault() {
    return SizedBox();
  }

  Widget ActFault() {
    return SizedBox();
  }
}
