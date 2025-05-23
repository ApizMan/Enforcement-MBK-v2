// ignore_for_file: deprecated_member_use

import 'package:dropdown_search/dropdown_search.dart';
import 'package:eo_apk_mbk_v2/form_blocs/form_bloc.dart';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/theme.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActFaultScreen extends StatelessWidget {
  final VehicleValidationFormBloc? vehicleValidationFormBloc;
  final CompoundParkingFormBloc? compoundParkingFormBloc;
  final List<UserModel> userModel;
  final List<OfficerUnitModel> unitModel;
  final String handHeldId;
  final List<VehicleTypeModel> vehicleTypeModel;
  final List<VehicleBrandModel> vehicleMakesModel;
  final List<VehicleModelsModel> vehicleModelsModel;
  final List<VehicleColorModel> vehicleColorModel;
  final List<OffenceActModel> offenceActModel;
  final List<OffenceSectionModel> offenceSectionModel;
  final List<OffenceAreaModel> offenceAreaModel;
  final List<OffenceLocationModel> offenceLocationModel;
  const ActFaultScreen({
    super.key,
    this.vehicleValidationFormBloc,
    this.compoundParkingFormBloc,
    required this.unitModel,
    required this.userModel,
    required this.handHeldId,
    required this.offenceActModel,
    required this.offenceAreaModel,
    required this.offenceLocationModel,
    required this.offenceSectionModel,
    required this.vehicleColorModel,
    required this.vehicleMakesModel,
    required this.vehicleModelsModel,
    required this.vehicleTypeModel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            BlocBuilder<SelectFieldBloc<OffenceActModel?, dynamic>,
                SelectFieldBlocState<OffenceActModel?, dynamic>>(
              bloc: compoundParkingFormBloc!.actLaw,
              builder: (context, state) {
                return DropdownSearch<OffenceActModel>(
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchDelay: Duration.zero,
                    itemBuilder: (context, item, isSelected) => ListTile(
                      title: Text(item.description ?? 'Unknown'),
                    ),
                    showSelectedItems: true,
                  ),
                  items: compoundParkingFormBloc!.actLaw.state.items,
                  selectedItem: state.value,
                  compareFn: (a, b) => a.id == b.id,
                  itemAsString: (item) => item.description ?? '',
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.legalProvisions,
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
                  ),
                  onChanged: (value) {
                    compoundParkingFormBloc!.actLaw.updateValue(value);
                  },
                  filterFn: (item, filter) {
                    return item.description
                            ?.toLowerCase()
                            .contains(filter.toLowerCase()) ??
                        false;
                  },
                );
              },
            ),

            spaceVertical(height: 10.0),

            BlocBuilder<SelectFieldBloc<OffenceSectionModel?, dynamic>,
                SelectFieldBlocState<OffenceSectionModel?, dynamic>>(
              bloc: compoundParkingFormBloc!.section,
              builder: (context, state) {
                return DropdownSearch<OffenceSectionModel>(
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchDelay: Duration.zero,
                    itemBuilder: (context, item, isSelected) => ListTile(
                      title: Text(item.subsectionNo != null
                          ? 'PERINTAH ${item.sectionNo}${item.subsectionNo}'
                          : 'PERINTAH ${item.sectionNo}'),
                    ),
                    showSelectedItems: true,
                  ),
                  items: compoundParkingFormBloc!.section.state.items,
                  selectedItem: state.value,
                  compareFn: (a, b) => a.id == b.id,
                  itemAsString: (item) => item.subsectionNo != null
                      ? '${item.sectionNo}${item.subsectionNo}'
                      : item.sectionNo ?? '',
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.sectionOrOrderOrMethod,
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
                  ),
                  onChanged: (value) {
                    compoundParkingFormBloc!.section.updateValue(value);
                  },
                  filterFn: (item, filter) {
                    final section = item.sectionNo ?? '';
                    final subsection = item.subsectionNo ?? '';
                    final combined = subsection.isNotEmpty
                        ? 'PERINTAH $section$subsection'
                        : 'PERINTAH $section';
                    return combined
                        .toLowerCase()
                        .contains(filter.toLowerCase());
                  },
                );
              },
            ),

            spaceVertical(height: 10.0),

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

            spaceVertical(height: 10.0),

            BlocBuilder<SelectFieldBloc<OffenceAreaModel?, dynamic>,
                SelectFieldBlocState<OffenceAreaModel?, dynamic>>(
              bloc: compoundParkingFormBloc!.area,
              builder: (context, state) {
                return DropdownSearch<OffenceAreaModel>(
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchDelay: Duration.zero,
                    itemBuilder: (context, item, isSelected) => ListTile(
                      title: Text(item.description ?? 'Unknown'),
                    ),
                    showSelectedItems: true,
                  ),
                  items: compoundParkingFormBloc!.area.state.items,
                  selectedItem: state.value,
                  compareFn: (a, b) => a.id == b.id,
                  itemAsString: (item) => item.description ?? '',
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.zone,
                      prefixIcon: const Icon(
                        Icons.flag,
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
                  onChanged: (value) {
                    compoundParkingFormBloc!.area.updateValue(value);
                  },
                  filterFn: (item, filter) {
                    return item.description
                            ?.toLowerCase()
                            .contains(filter.toLowerCase()) ??
                        false;
                  },
                );
              },
            ),

            spaceVertical(height: 15.0),

            BlocBuilder<SelectFieldBloc<OffenceLocationModel?, dynamic>,
                SelectFieldBlocState<OffenceLocationModel?, dynamic>>(
              bloc: compoundParkingFormBloc!.placement,
              builder: (context, state) {
                return DropdownSearch<OffenceLocationModel>(
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchDelay: Duration.zero,
                    itemBuilder: (context, item, isSelected) => ListTile(
                      title: Text(item.description ?? 'Unknown'),
                    ),
                    showSelectedItems: true,
                  ),
                  items: compoundParkingFormBloc!.placement.state.items,
                  selectedItem: state.value,
                  compareFn: (a, b) => a.id == b.id,
                  itemAsString: (item) => item.description ?? '',
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.placement,
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
                  ),
                  onChanged: (value) {
                    compoundParkingFormBloc!.placement.updateValue(value);
                  },
                  filterFn: (item, filter) {
                    return item.description
                            ?.toLowerCase()
                            .contains(filter.toLowerCase()) ??
                        false;
                  },
                );
              },
            ),

            spaceVertical(height: 10.0),

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
