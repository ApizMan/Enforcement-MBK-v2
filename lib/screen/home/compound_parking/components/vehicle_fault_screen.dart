// ignore_for_file: deprecated_member_use

import 'package:dropdown_search/dropdown_search.dart';
import 'package:eo_apk_mbk_v2/form_blocs/form_bloc.dart';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';
import 'package:eo_apk_mbk_v2/helpers/theme.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:eo_apk_mbk_v2/routes/route_manager.dart';
import 'package:eo_apk_mbk_v2/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VehicleFaultScreen extends StatefulWidget {
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
  const VehicleFaultScreen({
    super.key,
    required this.vehicleValidationFormBloc,
    required this.compoundParkingFormBloc,
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
  State<VehicleFaultScreen> createState() => _VehicleFaultScreenState();
}

class _VehicleFaultScreenState extends State<VehicleFaultScreen> {
  late String verifyDesc = '';

  @override
  void initState() {
    super.initState();
    _getVerifyVehicleDesc();
  }

  Future<void> _getVerifyVehicleDesc() async {
    final result = await SharedPreferencesHelper.getVerifyVehicleDesc();
    setState(() {
      verifyDesc = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VehicleValidationFormBloc, FormBlocState>(
      bloc: widget.vehicleValidationFormBloc!,
      listener: (context, state) async {
        if (state is FormBlocSuccess) {
          await _getVerifyVehicleDesc();
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFieldBlocBuilder(
                          textFieldBloc:
                              widget.vehicleValidationFormBloc!.plateNumber,
                          textInputAction: TextInputAction.done,
                          textCapitalization:
                              TextCapitalization.characters, // Force uppercase
                          inputFormatters: [
                            UpperCaseTextFormatter(), // Custom formatter to enforce it
                          ],
                          decoration: InputDecoration(
                            label:
                                Text(AppLocalizations.of(context)!.plateNumber),
                            prefixIcon: const Icon(Icons.abc_rounded,
                                color: accentCanvasColor),
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
                        const SizedBox(height: 5),
                        Visibility(
                          visible: verifyDesc.isNotEmpty,
                          child: Text(
                            verifyDesc,
                            style: TextStyle(
                              color: verifyDesc.contains('Berbayar')
                                  ? Colors.green
                                  : kRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  spaceHorizontal(width: 10.0),
                  PrimaryButton(
                    buttonWidth: 0.3,
                    borderRadius: 10.0,
                    color: accentCanvasColor,
                    onPressed: () => widget.vehicleValidationFormBloc!.submit(),
                    label: Text(
                      AppLocalizations.of(context)!.verify,
                      style: textStyleNormal(color: kWhite, fontSize: 10),
                    ),
                  ),
                ],
              ),

              TextFieldBlocBuilder(
                textFieldBloc: widget.compoundParkingFormBloc!.taxNumber,
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

              spaceVertical(height: 5.0),

              BlocBuilder<SelectFieldBloc<VehicleTypeModel?, dynamic>,
                  SelectFieldBlocState<VehicleTypeModel?, dynamic>>(
                bloc: widget.compoundParkingFormBloc!.type,
                builder: (context, state) {
                  return DropdownSearch<VehicleTypeModel>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchDelay:
                          Duration.zero, // Optional: remove debounce delay
                      itemBuilder: (context, item, isSelected) => ListTile(
                        title: Text(item.description ?? 'Unknown'),
                      ),
                      // Optional: for better UX
                      showSelectedItems: true,
                    ),
                    items: widget.vehicleTypeModel,
                    selectedItem: state.value,
                    compareFn: (a, b) => a.id == b.id, // ✅ Add this line
                    itemAsString: (item) => item.description ?? '',
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.bodyType,
                        prefixIcon: const Icon(Icons.car_rental_rounded,
                            color: accentCanvasColor),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: kBlack),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    onChanged: (value) {
                      widget.compoundParkingFormBloc!.type.updateValue(value);
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

              BlocBuilder<SelectFieldBloc<VehicleBrandModel?, dynamic>,
                  SelectFieldBlocState<VehicleBrandModel?, dynamic>>(
                bloc: widget.compoundParkingFormBloc!.brand,
                builder: (context, state) {
                  return DropdownSearch<VehicleBrandModel>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchDelay: Duration.zero,
                      itemBuilder: (context, item, isSelected) => ListTile(
                        title: Text(item.description ?? 'Unknown'),
                      ),
                      showSelectedItems: true,
                    ),
                    // ✅ Make sure 'Lain-Lain' is in the list
                    items: [
                      ...widget.vehicleMakesModel,
                      CompoundParkingFormBloc.otherMakeItem
                    ],
                    selectedItem: state.value,
                    compareFn: (a, b) => a.id == b.id,
                    itemAsString: (item) => item.description ?? '',
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.brands,
                        prefixIcon: const Icon(
                          Icons.car_repair,
                          color: accentCanvasColor,
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: kBlack),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    onChanged: (value) {
                      widget.compoundParkingFormBloc!.brand.updateValue(value);
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

              spaceVertical(height: 5.0),

              /// Visibility for "Lain-Lain" Make Text Field
              BlocBuilder<BooleanFieldBloc, BooleanFieldBlocState>(
                bloc: widget.compoundParkingFormBloc!.showOtherBrand,
                builder: (context, state) {
                  return Visibility(
                    visible: state.value,
                    child: TextFieldBlocBuilder(
                      textFieldBloc: widget.compoundParkingFormBloc!.otherBrand,
                      decoration: InputDecoration(
                        label: Text(
                          '${AppLocalizations.of(context)!.others} ${AppLocalizations.of(context)!.brands}',
                        ),
                        prefixIcon: const Icon(
                          Icons.add_circle_sharp,
                          color: accentCanvasColor,
                        ),
                        hintText:
                            '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.others} ${AppLocalizations.of(context)!.brands}',
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

              spaceVertical(height: 5.0),

              BlocBuilder<SelectFieldBloc<VehicleModelsModel?, dynamic>,
                  SelectFieldBlocState<VehicleModelsModel?, dynamic>>(
                bloc: widget.compoundParkingFormBloc!.model,
                builder: (context, state) {
                  return DropdownSearch<VehicleModelsModel>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchDelay: Duration.zero,
                      itemBuilder: (context, item, isSelected) => ListTile(
                        title: Text(item.description ?? 'Unknown'),
                      ),
                      showSelectedItems: true,
                    ),
                    items: widget.compoundParkingFormBloc!.model.state.items,
                    selectedItem: state.value,
                    compareFn: (a, b) => a.id == b.id,
                    itemAsString: (item) => item.description ?? '',
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.model,
                        prefixIcon: const Icon(
                          Icons.car_crash_sharp,
                          color: accentCanvasColor,
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: kBlack),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    onChanged: (value) {
                      widget.compoundParkingFormBloc!.model.updateValue(value);
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

              spaceVertical(height: 5.0),

              /// Visibility for "Lain-Lain" Model Text Field
              BlocBuilder<BooleanFieldBloc, BooleanFieldBlocState>(
                bloc: widget.compoundParkingFormBloc!.showOtherModel,
                builder: (context, state) {
                  return Visibility(
                    visible: state.value,
                    child: TextFieldBlocBuilder(
                      textFieldBloc: widget.compoundParkingFormBloc!.otherModel,
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

              spaceVertical(height: 5.0),

              BlocBuilder<SelectFieldBloc<VehicleColorModel?, dynamic>,
                  SelectFieldBlocState<VehicleColorModel?, dynamic>>(
                bloc: widget.compoundParkingFormBloc!.color,
                builder: (context, state) {
                  return DropdownSearch<VehicleColorModel>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchDelay: Duration.zero,
                      itemBuilder: (context, item, isSelected) => ListTile(
                        title: Text(item.description ?? 'Unknown'),
                      ),
                      showSelectedItems: true,
                    ),
                    items: widget.compoundParkingFormBloc!.color.state.items,
                    selectedItem: state.value,
                    compareFn: (a, b) => a.id == b.id,
                    itemAsString: (item) => item.description ?? '',
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.color,
                        prefixIcon: const Icon(
                          Icons.color_lens,
                          color: accentCanvasColor,
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: kBlack),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    onChanged: (value) {
                      widget.compoundParkingFormBloc!.color.updateValue(value);
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

              spaceVertical(height: 5.0),

              BlocBuilder<BooleanFieldBloc, BooleanFieldBlocState>(
                bloc: widget.compoundParkingFormBloc!.showOtherColor,
                builder: (context, state) {
                  return Visibility(
                    visible: state.value,
                    child: TextFieldBlocBuilder(
                      textFieldBloc: widget.compoundParkingFormBloc!.otherColor,
                      decoration: InputDecoration(
                        label: Text(
                          '${AppLocalizations.of(context)!.others} ${AppLocalizations.of(context)!.color}',
                        ),
                        prefixIcon: const Icon(
                          Icons.add_circle_sharp,
                          color: accentCanvasColor,
                        ),
                        hintText:
                            '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.others} ${AppLocalizations.of(context)!.color}',
                        hintStyle: const TextStyle(color: Colors.black26),
                        border: OutlineInputBorder(
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

              spaceVertical(height: 20.0),

              PrimaryButton(
                buttonWidth: 1,
                borderRadius: 10.0,
                color: accentCanvasColor,
                onPressed: () => Navigator.pushNamed(
                    context, RouteManager.cameraScreen,
                    arguments: {
                      'compoundParkingFormBloc': widget.compoundParkingFormBloc,
                    }),
                label: Text(
                  AppLocalizations.of(context)!.camera,
                  style: textStyleNormal(color: kWhite),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
