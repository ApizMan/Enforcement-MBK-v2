import 'dart:async';

import 'package:eo_apk_mbk_v2/helpers/validators.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class CompoundParkingFormBloc extends FormBloc<String, String> {
  final List<VehicleBrandModel> vehicleMakesModel;
  final List<VehicleModelsModel> vehicleModelsModel;
  final List<VehicleTypeModel> vehicleTypeModel;
  final List<VehicleColorModel> vehicleColorModel;
  final List<OffenceActModel> offenceActModel;
  final List<OffenceSectionModel> offenceSectionModel;
  final List<OffenceAreaModel> offenceAreaModel;
  final List<OffenceLocationModel> offenceLocationModel;

  // First Page
  final taxNumber = TextFieldBloc(validators: [InputValidator.required]);

  final type = SelectFieldBloc<VehicleTypeModel, dynamic>(
    validators: [InputValidator.required],
  );

  final brand = SelectFieldBloc<VehicleBrandModel, dynamic>(
    validators: [InputValidator.required],
  );

  final model = SelectFieldBloc<VehicleModelsModel, dynamic>(
    validators: [InputValidator.required],
  );

  final color = SelectFieldBloc<VehicleColorModel, dynamic>(
    validators: [InputValidator.required],
  );

  final otherBrand = TextFieldBloc();
  final otherModel = TextFieldBloc();
  final showOtherBrand = BooleanFieldBloc();
  final showOtherModel = BooleanFieldBloc();

  // Second Page
  final actLaw = SelectFieldBloc<OffenceActModel, dynamic>(
    validators: [InputValidator.required],
  );

  final section = SelectFieldBloc<OffenceSectionModel, dynamic>(
    validators: [InputValidator.required],
  );

  final fault = TextFieldBloc(validators: [InputValidator.required]);

  final area = SelectFieldBloc<OffenceAreaModel, dynamic>(
    validators: [InputValidator.required],
  );

  final locations = SelectFieldBloc<OffenceLocationModel, dynamic>(
    validators: [InputValidator.required],
  );

  static final VehicleBrandModel otherMakeItem = VehicleBrandModel(
    id: '__other_make__',
    description: 'Lain-Lain',
  );

  static final VehicleModelsModel otherTypeItem = VehicleModelsModel(
    id: '__other_model__',
    makeId: '__other_make__',
    description: 'Lain-Lain',
  );

  CompoundParkingFormBloc({
    required this.vehicleTypeModel,
    required this.vehicleMakesModel,
    required this.vehicleModelsModel,
    required this.vehicleColorModel,
    required this.offenceActModel,
    required this.offenceSectionModel,
    required this.offenceAreaModel,
    required this.offenceLocationModel,
  }) {
    // --- First Page Setup ---
    type.updateItems(vehicleTypeModel);
    color.updateItems(vehicleColorModel);

    // Add 'Lain-Lain' brand
    final updatedMakes = [...vehicleMakesModel, otherMakeItem];
    brand.updateItems(updatedMakes);

    // Listen Brand Selection
    brand.stream.listen((value) {
      final selectedMake = value.value;

      if (selectedMake != null) {
        showOtherBrand.updateValue(selectedMake.id == '__other_make__');

        if (selectedMake.id != '__other_make__') {
          final filteredModels =
              vehicleModelsModel
                  .where((type) => type.makeId == selectedMake.id)
                  .toList();
          model.updateItems([...filteredModels, otherTypeItem]);
        } else {
          model.updateItems([]);
        }

        model.clear();
        showOtherModel.updateValue(false);
      }
    });

    otherBrand.stream.listen((value) {
      final isOtherBrandFilled = value.value.trim().isNotEmpty;

      if (isOtherBrandFilled) {
        brand.updateValue(otherMakeItem);
        model.updateItems([otherTypeItem]);
        model.updateValue(null);
        showOtherModel.updateValue(false);
      } else {
        model.updateItems([]);
        model.updateValue(null);
        showOtherModel.updateValue(false);
      }
    });

    model.stream.listen((value) {
      final selectedModel = value.value;
      showOtherModel.updateValue(selectedModel?.id == '__other_model__');
    });

    // --- Second Page Setup (Act & Section) ---
    actLaw.updateItems(offenceActModel);
    area.updateItems(offenceAreaModel);
    locations.updateItems(offenceLocationModel);

    actLaw.stream.listen((value) {
      final selectedAct = value.value;

      if (selectedAct != null) {
        final filteredSections =
            offenceSectionModel
                .where((section) => section.actId == selectedAct.id)
                .toList();

        section.updateItems(filteredSections);
      } else {
        section.updateItems([]);
      }

      section.clear();
    });

    // 🔽 New code to auto-fill fault field from selected section
    section.stream.listen((value) {
      final selectedSection = value.value;
      if (selectedSection != null) {
        fault.updateValue(selectedSection.description ?? '');
      } else {
        fault.updateValue('');
      }
    });

    addFieldBlocs(
      fieldBlocs: [
        // First Page
        taxNumber,
        type,
        brand,
        model,
        otherBrand,
        otherModel,
        showOtherBrand,
        showOtherModel,
        color,

        // Second Page
        actLaw,
        section,
        fault,
        area,
      ],
    );
  }

  @override
  FutureOr<void> onSubmitting() {
    emitSuccess();
  }
}
