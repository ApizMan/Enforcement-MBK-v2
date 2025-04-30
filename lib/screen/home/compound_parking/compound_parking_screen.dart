// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'package:eo_apk_mbk_v2/form_blocs/form_bloc.dart';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/theme.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:eo_apk_mbk_v2/routes/route_manager.dart';
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
      children: [
        VehicleFault(context),
        ActFault(context),
        SummaryFault(context),
      ],
    );
  }

  Widget VehicleFault(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              // PLate Number field
              Expanded(
                child: TextFieldBlocBuilder(
                  textFieldBloc: vehicleValidationFormBloc!.plateNumber,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.plateNumber),
                    prefixIcon: const Icon(
                      Icons.abc_rounded,
                      color: accentCanvasColor,
                    ),
                    hintText:
                        '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.plateNumber}',
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
                color: accentCanvasColor,
                onPressed: () => vehicleValidationFormBloc!.submit(),
                label: Text(
                  AppLocalizations.of(context)!.verify,
                  style: textStyleNormal(color: kWhite),
                ),
              ),
            ],
          ),
          TextFieldBlocBuilder(
            textFieldBloc: compoundParkingFormBloc!.taxNumber,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.taxRoadNumber),
              prefixIcon: const Icon(
                Icons.flag_circle,
                color: accentCanvasColor,
              ),
              hintText:
                  '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.taxRoadNumber}',
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

          DropdownFieldBlocBuilder<VehicleTypeModel?>(
            showEmptyItem: false,
            selectFieldBloc: compoundParkingFormBloc!.type,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.bodyType),
              prefixIcon: const Icon(
                Icons.car_rental_rounded,
                color: accentCanvasColor,
              ),
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
            itemBuilder: (context, value) {
              return FieldItem(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(value?.description ?? 'Unknown'),
                ),
              );
            },
          ),

          DropdownFieldBlocBuilder<VehicleBrandModel?>(
            showEmptyItem: false,
            selectFieldBloc: compoundParkingFormBloc!.brand,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.brands),
              prefixIcon: const Icon(
                Icons.car_repair,
                color: accentCanvasColor,
              ),
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
            itemBuilder: (context, value) {
              return FieldItem(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(value?.description ?? 'Unknown'),
                ),
              );
            },
          ),

          /// Visibility for "Lain-Lain" Make Text Field
          BlocBuilder<BooleanFieldBloc, BooleanFieldBlocState>(
            bloc: compoundParkingFormBloc!.showOtherBrand,
            builder: (context, state) {
              return Visibility(
                visible: state.value,
                child: TextFieldBlocBuilder(
                  textFieldBloc: compoundParkingFormBloc!.otherBrand,
                  decoration: InputDecoration(
                    label: Text(
                      '${AppLocalizations.of(context)!.others} ${AppLocalizations.of(context)!.brands}',
                    ),
                    prefixIcon: const Icon(
                      Icons.add_circle_sharp,
                      color: accentCanvasColor,
                    ),
                    hintText:
                        '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.others} ${AppLocalizations.of(context)!.bodyType}',
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
              );
            },
          ),

          DropdownFieldBlocBuilder<VehicleModelsModel?>(
            showEmptyItem: false,
            selectFieldBloc: compoundParkingFormBloc!.model,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.model),
              prefixIcon: const Icon(
                Icons.car_crash_sharp,
                color: accentCanvasColor,
              ),
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
            itemBuilder: (context, value) {
              return FieldItem(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(value?.description ?? 'Unknown'),
                ),
              );
            },
          ),

          /// Visibility for "Lain-Lain" Model Text Field
          BlocBuilder<BooleanFieldBloc, BooleanFieldBlocState>(
            bloc: compoundParkingFormBloc!.showOtherModel,
            builder: (context, state) {
              return Visibility(
                visible: state.value,
                child: TextFieldBlocBuilder(
                  textFieldBloc: compoundParkingFormBloc!.otherModel,
                  decoration: InputDecoration(
                    label: Text(
                      '${AppLocalizations.of(context)!.others} ${AppLocalizations.of(context)!.model}',
                    ),
                    prefixIcon: const Icon(
                      Icons.add_circle_sharp,
                      color: accentCanvasColor,
                    ),
                    hintText:
                        '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.others} ${AppLocalizations.of(context)!.model}',
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
              );
            },
          ),

          DropdownFieldBlocBuilder<VehicleColorModel?>(
            showEmptyItem: false,
            selectFieldBloc: compoundParkingFormBloc!.color,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.color),
              prefixIcon: const Icon(
                Icons.color_lens,
                color: accentCanvasColor,
              ),
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
            itemBuilder: (context, value) {
              return FieldItem(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(value?.description ?? 'Unknown'),
                ),
              );
            },
          ),

          spaceVertical(height: 20.0),

          PrimaryButton(
            buttonWidth: 1,
            borderRadius: 10.0,
            color: accentCanvasColor,
            onPressed:
                () => Navigator.pushNamed(context, RouteManager.cameraScreen),
            label: Text(
              AppLocalizations.of(context)!.camera,
              style: textStyleNormal(color: kWhite),
            ),
          ),
        ],
      ),
    );
  }

  Widget ActFault(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          DropdownFieldBlocBuilder<OffenceActModel?>(
            showEmptyItem: false,
            selectFieldBloc: compoundParkingFormBloc!.actLaw,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.legalProvisions),
              prefixIcon: const Icon(
                Icons.account_balance_rounded,
                color: accentCanvasColor,
              ),
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
            itemBuilder: (context, value) {
              return FieldItem(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(value?.description ?? 'Unknown'),
                ),
              );
            },
          ),

          DropdownFieldBlocBuilder<OffenceSectionModel?>(
            showEmptyItem: false,
            selectFieldBloc: compoundParkingFormBloc!.section,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.sectionOrOrderOrMethod),
              prefixIcon: const Icon(
                Icons.account_box_rounded,
                color: accentCanvasColor,
              ),
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
            itemBuilder: (context, value) {
              return FieldItem(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(value?.sectionNo ?? 'Unknown'),
                ),
              );
            },
          ),

          BlocBuilder<
            SelectFieldBloc<OffenceSectionModel, dynamic>,
            SelectFieldBlocState<OffenceSectionModel, dynamic>
          >(
            bloc: compoundParkingFormBloc!.section,
            builder: (context, state) {
              final hasSelection = state.value != null;

              return SizedBox(
                height: hasSelection ? 200 : null,
                child: TextFieldBlocBuilder(
                  expands: hasSelection,
                  maxLines: hasSelection ? null : 1,
                  minLines: hasSelection ? null : 1,
                  isEnabled: false,
                  textFieldBloc: compoundParkingFormBloc!.fault,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.fault),
                    prefixIcon: const Icon(
                      Icons.error,
                      color: accentCanvasColor,
                    ),
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
              );
            },
          ),

          DropdownFieldBlocBuilder<OffenceAreaModel?>(
            showEmptyItem: false,
            selectFieldBloc: compoundParkingFormBloc!.area,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.zone),
              prefixIcon: const Icon(Icons.flag, color: accentCanvasColor),
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
            itemBuilder: (context, value) {
              return FieldItem(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(value?.description ?? 'Unknown'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget SummaryFault(BuildContext context) {
    return SizedBox();
  }
}
