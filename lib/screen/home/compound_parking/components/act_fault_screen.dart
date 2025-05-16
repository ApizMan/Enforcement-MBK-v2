// ignore_for_file: deprecated_member_use

import 'package:eo_apk_mbk_v2/form_blocs/form_bloc.dart';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActFaultScreen extends StatelessWidget {
  final VehicleValidationFormBloc? vehicleValidationFormBloc;
  final CompoundParkingFormBloc? compoundParkingFormBloc;
  const ActFaultScreen({
    super.key,
    this.vehicleValidationFormBloc,
    this.compoundParkingFormBloc,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
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
                label: Text(
                  AppLocalizations.of(context)!.sectionOrOrderOrMethod,
                ),
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

            BlocBuilder<SelectFieldBloc<OffenceSectionModel, dynamic>,
                SelectFieldBlocState<OffenceSectionModel, dynamic>>(
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

            DropdownFieldBlocBuilder<OffenceLocationModel?>(
              showEmptyItem: false,
              selectFieldBloc: compoundParkingFormBloc!.placement,
              decoration: InputDecoration(
                label: Text(AppLocalizations.of(context)!.placement),
                prefixIcon: const Icon(
                  Icons.location_on,
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
              bloc: compoundParkingFormBloc!.showOtherPlacement,
              builder: (context, state) {
                return Visibility(
                  visible: state.value,
                  child: TextFieldBlocBuilder(
                    textFieldBloc: compoundParkingFormBloc!.otherPlacement,
                    decoration: InputDecoration(
                      label: Text(
                        '${AppLocalizations.of(context)!.others} ${AppLocalizations.of(context)!.placement}',
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

            TextFieldBlocBuilder(
              textFieldBloc: compoundParkingFormBloc!.locationDetail,
              decoration: InputDecoration(
                label: Text(AppLocalizations.of(context)!.locationDetail),
                prefixIcon: const Icon(
                  Icons.location_city,
                  color: accentCanvasColor,
                ),
                hintText:
                    '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.locationDetail}',
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

            TextFieldBlocBuilder(
              textFieldBloc: compoundParkingFormBloc!.squarePoleNo,
              decoration: InputDecoration(
                label: Text(AppLocalizations.of(context)!.squarePoleNumber),
                prefixIcon: const Icon(
                  Icons.format_list_numbered,
                  color: accentCanvasColor,
                ),
                hintText:
                    '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.squarePoleNumber}',
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

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: RadioButtonGroupFieldBlocBuilder<String>(
                groupStyle: FlexGroupStyle(direction: Axis.horizontal),
                selectFieldBloc: compoundParkingFormBloc!.vehicleClamping,
                decoration: InputDecoration(
                  label: Text(AppLocalizations.of(context)!.vehicleClamping),
                  prefixIcon: const Icon(
                    Icons.format_list_numbered,
                    color: accentCanvasColor,
                  ),
                  hintText:
                      '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.vehicleClamping}',
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
                itemBuilder: (context, item) => FieldItem(child: Text(item)),
              ),
            ),

            TextFieldBlocBuilder(
              textFieldBloc: compoundParkingFormBloc!.notes,
              decoration: InputDecoration(
                label: Text(AppLocalizations.of(context)!.notes),
                prefixIcon: const Icon(Icons.note, color: accentCanvasColor),
                hintText:
                    '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.notes}',
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
          ],
        ),
      ),
    );
  }
}
