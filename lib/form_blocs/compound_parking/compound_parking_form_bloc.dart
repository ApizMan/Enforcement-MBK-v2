import 'dart:async';
import 'dart:convert';
import 'package:eo_apk_mbk_v2/form_blocs/form_bloc.dart';
import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';
import 'package:eo_apk_mbk_v2/helpers/validators.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:eo_apk_mbk_v2/resources/resources.dart';
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
  final VehicleValidationFormBloc vehicleValidationFormBloc;

  // First Page
  final taxNumber = TextFieldBloc();

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

  final placement = SelectFieldBloc<OffenceLocationModel, dynamic>(
    validators: [InputValidator.required],
  );

  final otherPlacement = TextFieldBloc();
  final showOtherPlacement = BooleanFieldBloc();

  final locationDetail = TextFieldBloc();
  final squarePoleNo = TextFieldBloc();

  final vehicleClamping = SelectFieldBloc<String, dynamic>(
    initialValue: 'Tidak',
    items: ['Ya', 'Tidak'],
  );

  final notes = TextFieldBloc();
  final dateTime = TextFieldBloc();

  final imageName1 = TextFieldBloc();
  final imageName2 = TextFieldBloc();
  final imageName3 = TextFieldBloc();
  final imageName4 = TextFieldBloc();

  static final VehicleBrandModel otherMakeItem = VehicleBrandModel(
    id: '__other_make__',
    description: 'Lain-Lain',
  );

  static final VehicleModelsModel otherTypeItem = VehicleModelsModel(
    id: '__other_model__',
    makeId: '__other_make__',
    description: 'Lain-Lain',
  );

  static final OffenceLocationModel otherPlacementItem = OffenceLocationModel(
    id: '__other_placement__',
    areaID: '__other_placement__',
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
    required this.vehicleValidationFormBloc,
  }) {
    // --- First Page Setup ---
    type.updateItems(vehicleTypeModel);
    color.updateItems(vehicleColorModel);

    final updatedMakes = [...vehicleMakesModel, otherMakeItem];
    brand.updateItems(updatedMakes);

    brand.stream.listen((value) {
      final selectedMake = value.value;

      if (selectedMake != null) {
        showOtherBrand.updateValue(selectedMake.id == '__other_make__');

        if (selectedMake.id != '__other_make__') {
          final filteredModels = vehicleModelsModel
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

        // Always include 'Lain-Lain' for otherBrand
        model.updateItems([otherTypeItem]);
        model.updateValue(otherTypeItem); // Directly select 'Lain-Lain'
        showOtherModel.updateValue(true);
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

    // --- Second Page Setup (Act & Section & Area & Location) ---
    actLaw.updateItems(offenceActModel);
    area.updateItems(offenceAreaModel);

    actLaw.stream.listen((value) {
      final selectedAct = value.value;

      if (selectedAct != null) {
        final filteredSections = offenceSectionModel
            .where((section) => section.actId == selectedAct.id)
            .toList();
        section.updateItems(filteredSections);
      } else {
        section.updateItems([]);
      }

      section.clear();
    });

    section.stream.listen((value) {
      final selectedSection = value.value;
      if (selectedSection != null) {
        fault.updateValue(selectedSection.description ?? '');
      } else {
        fault.updateValue('');
      }
    });

    area.stream.listen((value) {
      final selectedArea = value.value;

      if (selectedArea != null) {
        final filteredLocations = offenceLocationModel
            .where((location) => location.areaID == selectedArea.id)
            .toList();
        placement.updateItems([...filteredLocations, otherPlacementItem]);
      } else {
        placement.updateItems([]);
      }

      placement.clear();
    });

    placement.stream.listen((value) {
      final selectedLocation = value.value;
      final selectedArea = area.value;

      final shouldShow =
          selectedLocation?.id == '__other_placement__' && selectedArea != null;

      showOtherPlacement.updateValue(shouldShow);
    });

    otherPlacement.stream.listen((value) {
      final isOtherLocationFilled = value.value.trim().isNotEmpty;

      if (isOtherLocationFilled) {
        placement.updateValue(otherPlacementItem);
        showOtherPlacement.updateValue(true);
      } else {
        placement.updateValue(null);
        showOtherPlacement.updateValue(false);
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
        placement,
        otherPlacement,
        showOtherPlacement,
        locationDetail,
        squarePoleNo,
        vehicleClamping,
        notes,

        // Third Page
        dateTime,
        imageName1,
        imageName2,
        imageName3,
        imageName4,
      ],
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    try {
      final officerData = await SharedPreferencesHelper.getLoginCredential();
      final officerMobile = await SharedPreferencesHelper.getHandheldId();
      final compoundModel = OfficerCompoundModel();

      // ✅ Get current serial and pad it
      int serial = await SharedPreferencesHelper.getNoticeSerialNumber();
      final paddedSerial = serial.toString().padLeft(5, '0');

      // ✅ Generate notice number
      compoundModel.noticeNo = '${officerMobile}25$paddedSerial';

      compoundModel.officerId = officerData['id'];
      compoundModel.officerUnit = officerData['unit'];
      compoundModel.officerSaksi = officerData['witness'];
      compoundModel.handheldCode = officerMobile;
      compoundModel.vehicleNo = vehicleValidationFormBloc.plateNumber.value;
      compoundModel.roadTaxNo = taxNumber.value;
      compoundModel.vehicleType = type.value!.description;
      compoundModel.vehicleColor = color.value!.description;
      compoundModel.squarePoleNo = squarePoleNo.value;
      compoundModel.noticeNo = '${officerMobile}25$paddedSerial';
      compoundModel.offenceSectionCode = section.value!.id;
      compoundModel.offenceDateString = dateTime.value;

      compoundModel.offenceArea = area.value!.description;

      compoundModel.imageName1 = imageName1.value;
      compoundModel.imageName2 = imageName2.value;
      compoundModel.imageName3 = imageName3.value;
      compoundModel.imageName4 = imageName4.value;

      compoundModel.notes = notes.value;

      // Get the compound amount (amount3)
      final selectedSection = offenceSectionModel.firstWhere(
          (s) => s.id == section.value!.id,
          orElse: () => OffenceSectionModel());

      compoundModel.compoundAmount = selectedSection.amount3 ?? 0;

      if (placement.value != null) {
        final isOtherPlacement = placement.value!.id == '__other_placement__';
        final otherPlacementText = otherPlacement.value.trim();

        if (isOtherPlacement && otherPlacementText.isNotEmpty) {
          compoundModel.offenceLocation = 'Lain-Lain - $otherPlacementText';
        } else {
          compoundModel.offenceLocation = placement.value!.description;
        }
      } else {
        compoundModel.offenceLocation = null;
      }

      compoundModel.offenceLocationDetails = locationDetail.value;

      if (vehicleClamping.value == 'Ya') {
        compoundModel.isClamping = true;
      } else {
        compoundModel.isClamping = false;
      }

      if (brand.value != null && model.value != null) {
        final isOtherBrand = brand.value!.id == '__other_make__';
        final isOtherModel = model.value!.id == '__other_model__';

        final otherBrandText = otherBrand.value.trim();
        final otherModelText = otherModel.value.trim();

        if (isOtherBrand && isOtherModel) {
          compoundModel.vehicleMakeModel =
              'Lain-Lain - $otherBrandText - $otherModelText';
        } else if (isOtherBrand) {
          compoundModel.vehicleMakeModel =
              'Lain-Lain - $otherBrandText - ${model.value!.description}';
        } else if (isOtherModel) {
          compoundModel.vehicleMakeModel =
              '${brand.value!.description} - Lain-Lain - $otherModelText';
        } else {
          compoundModel.vehicleMakeModel =
              '${brand.value!.description} - ${model.value!.description}';
        }
      }

      // 🚨 Validate vehicle image
      final imagePaths = await SharedPreferencesHelper.getCapturedImagePaths();
      final validImages =
          imagePaths.where((path) => path != null && path.isNotEmpty).toList();
      if (validImages.length < 2) {
        emitFailure(
          failureResponse: jsonEncode({
            'type': 'validation',
            'message': 'Sila ambil sekurang-kurangnya 2 gambar.',
          }),
        );

        return;
      }

      // 🚨 Validate placement
      if (placement.value == null) {
        emitFailure(failureResponse: "Sila Pilih Nama Jalan.");
        return;
      }

      // 🚨 If placement is 'Lain-Lain', validate otherPlacement
      final isOtherPlacement = placement.value!.id == '__other_placement__';
      final otherPlacementText = otherPlacement.value.trim();

      if (isOtherPlacement && otherPlacementText.isEmpty) {
        emitFailure(failureResponse: "Sila Pilih Nama Jalan.");
        return;
      }

      // Get Form Pending
      final noticePending =
          await SharedPreferencesHelper.getAllOfficerCompoundPendingModels();

      final isDuplicate = noticePending.any(
        (model) => model.noticeNo == compoundModel.noticeNo,
      );

      if (!isDuplicate) {
        // Save Form Pending
        await SharedPreferencesHelper.saveOfficerCompoundPendingModel(
            compoundModel);

        int incrementSerial = serial + 1;

        // ✅ Immediately increment for next use
        await SharedPreferencesHelper.setNoticeSerialNumber(incrementSerial);

        await SharedPreferencesHelper.clearVerifyVehicleDesc();
      } else {
        emitFailure(
          failureResponse: jsonEncode({
            'type': 'duplicate',
            'message': 'Please check duplicate copy for re-send back.',
          }),
        );
      }

      final responseEnforcementCCP =
          await UploadResources.uploadCompoundToEnforcementCCP(
              prefix: 'UploadNotice',
              body: {
            'NoticeNo': compoundModel.noticeNo.toString(),
            'VehicleNo': compoundModel.vehicleNo.toString(),
            'OfficerID': compoundModel.officerId.toString(),
            'OfficerUnit': compoundModel.officerUnit.toString(),
            'HandheldCode': compoundModel.handheldCode.toString(),
            'OffenceDateString': compoundModel.offenceDateString.toString(),
            'VehicleType': compoundModel.vehicleType.toString(),
            'VehicleColor': compoundModel.vehicleColor.toString(),
            'VehicleMakeModel': compoundModel.vehicleMakeModel.toString(),
            'RoadTaxNo': compoundModel.roadTaxNo.toString(),
            'OffenceSectionCode': compoundModel.offenceSectionCode.toString(),
            'OffenceArea': compoundModel.offenceArea.toString(),
            'OffenceLocation': compoundModel.offenceLocation.toString(),
            'OffenceLocationDetails':
                compoundModel.offenceLocationDetails.toString(),
            'SquarePoleNo': compoundModel.squarePoleNo.toString(),
            'ImageName1': compoundModel.imageName1.toString(),
            'ImageName2': compoundModel.imageName2.toString(),
            'ImageName3': compoundModel.imageName3.toString(),
            'ImageName4': compoundModel.imageName4.toString(),
            'ImageName5': compoundModel.imageName5.toString(),
            'IsClamping': compoundModel.isClamping.toString(),
            'Notes': compoundModel.notes.toString(),
            'Latitude': compoundModel.latitude,
            'Longitude': compoundModel.longitude,
            'CompoundAmount': compoundModel.compoundAmount,
            'OfficerSaksi': compoundModel.officerSaksi.toString(),
          });

      if (responseEnforcementCCP['StatusDescription'] == null) {
        await SharedPreferencesHelper.saveOfficerCompoundModel(compoundModel);

        await SharedPreferencesHelper.removeOfficerCompoundPendingByNoticeNo(
            compoundModel.noticeNo!);

        emitSuccess();
      } else {
        emitFailure(
            failureResponse: responseEnforcementCCP['StatusDescription']);
      }
    } catch (e) {
      emitFailure(
        failureResponse: jsonEncode({
          'type': 'network',
          'message':
              'Please check your internet connection. Re-check Duplicate Copy is there any pending.',
        }),
      );
    }
  }
}
