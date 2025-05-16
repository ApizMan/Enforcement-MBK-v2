import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';

enum ValidationForm {
  missingPlate,
  notPushed,
  missingBrand,
  missingModel,
  missingType,
  missingColor,
  missingActLaw,
  missingSection,
  missingArea,
  missingPlacement,
  missingImages, // ✅ Add this
  none,
}

Future<ValidationForm> validateForm(bloc, vehicleBloc, bool btnPush) async {
  final imagePaths = await SharedPreferencesHelper.getCapturedImagePaths();
  final validImages =
      imagePaths.where((path) => path != null && path.isNotEmpty).toList();

  if (validImages.length < 2) {
    return ValidationForm.missingImages;
  }

  if (vehicleBloc.plateNumber.value.isEmpty) {
    return ValidationForm.missingPlate;
  }
  if (!btnPush) return ValidationForm.notPushed;

  if (bloc.brand.value == null ||
      (bloc.brand.value?.id == '__other_make__' &&
          bloc.otherBrand.value.trim().isEmpty)) {
    return ValidationForm.missingBrand;
  }

  if (bloc.model.value == null ||
      (bloc.model.value?.id == '__other_model__' &&
          bloc.otherModel.value.trim().isEmpty)) {
    return ValidationForm.missingModel;
  }

  if (bloc.type.value == null) return ValidationForm.missingType;
  if (bloc.color.value == null) return ValidationForm.missingColor;
  if (bloc.actLaw.value == null) return ValidationForm.missingActLaw;
  if (bloc.section.value == null) return ValidationForm.missingSection;
  if (bloc.area.value == null) return ValidationForm.missingArea;

  // ✅ Placement check
  if (bloc.placement.value == null ||
      (bloc.placement.value?.id == '__other_placement__' &&
          bloc.otherPlacement.value.trim().isEmpty)) {
    return ValidationForm.missingPlacement;
  }

  return ValidationForm.none;
}
