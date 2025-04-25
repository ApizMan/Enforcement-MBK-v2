import 'dart:async';

import 'package:eo_apk_mbk_v2/helpers/validators.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class CompoundParkingFormBloc extends FormBloc<String, String> {
  final List<VehicleBrandModel> vehicleMakesModel;
  final List<VehicleModelsModel> vehicleModelsModel;
  final List<VehicleTypeModel> vehicleTypeModel;
  final List<VehicleColorModel> vehicleColorModel;

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

  // Use this to track if 'Lain-Lain' is selected
  final showOtherBrand = BooleanFieldBloc();
  final showOtherModel = BooleanFieldBloc();

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
  }) {
    type.updateItems(vehicleTypeModel);
    color.updateItems(vehicleColorModel);
    // Add "Lain-Lain" to list
    final updatedMakes = [...vehicleMakesModel, otherMakeItem];
    brand.updateItems(updatedMakes);

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
        // Set the brand dropdown to "Lain-Lain"
        brand.updateValue(otherMakeItem);

        // Populate model dropdown with just "Lain-Lain" if not already set
        model.updateItems([otherTypeItem]);
        model.updateValue(null); // Reset model selection
        showOtherModel.updateValue(false); // Initially hide otherModel
      } else {
        // Clear model if "otherBrand" is cleared
        model.updateItems([]);
        model.updateValue(null);
        showOtherModel.updateValue(false);
      }
    });

    model.stream.listen((value) {
      final selectedModel = value.value;
      showOtherModel.updateValue(selectedModel?.id == '__other_model__');
    });

    addFieldBlocs(
      fieldBlocs: [
        taxNumber,
        type,
        brand,
        model,
        otherBrand,
        otherModel,
        showOtherBrand,
        showOtherModel,
        color,
      ],
    );
  }

  @override
  FutureOr<void> onSubmitting() {
    emitSuccess();
  }
}
