import 'dart:async';

import 'package:eo_apk_mbk_v2/helpers/decryption_password.dart';
import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';
import 'package:eo_apk_mbk_v2/helpers/validators.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final List<UserModel> officerInfos;
  final LoginModel model = LoginModel();
  final List<OfficerUnitModel> officerUnits;

  final userId = TextFieldBloc(validators: [InputValidator.required]);
  final password = TextFieldBloc(validators: [InputValidator.required]);

  final unit = SelectFieldBloc<OfficerUnitModel, dynamic>(
    validators: [InputValidator.required],
  );

  final witness = SelectFieldBloc<UserModel, dynamic>(
    validators: [InputValidator.required],
  );

  LoginFormBloc({required this.officerInfos, required this.officerUnits}) {
    witness.updateItems(officerInfos);
    unit.updateItems(officerUnits);
    addFieldBlocs(fieldBlocs: [userId, password, unit, witness]);
  }

  @override
  FutureOr<void> onSubmitting() async {
    model.userId = userId.value;
    model.password = password.value;
    model.unit = unit.value?.description;
    model.witness = witness.value?.userId;

    try {
      // Find matching officer by checking decrypted password
      final matchedOfficer = officerInfos.firstWhere((officer) {
        try {
          final isValid = verifyHash(
            model.password!,
            officer.password!,
            hashType: 'MD5',
          );
          return officer.userId == model.userId && isValid;
        } catch (e) {
          print('❌ Hash failed for ${officer.name}: $e');
          return false;
        }
      }, orElse: () => UserModel());

      if (matchedOfficer.name == null || matchedOfficer.password == null) {
        emitFailure(failureResponse: 'Invalid officer credentials.');
        return;
      }

      await SharedPreferencesHelper.saveLoginCredential(
        model.userId!,
        model.password!,
        model.unit!,
        model.witness!,
      );

      emitSuccess();
    } catch (e) {
      if (kDebugMode) {
        print("🔴 Login exception: $e");
      }
      emitFailure(failureResponse: 'An error occurred. Please try again.');
    }
  }
}
