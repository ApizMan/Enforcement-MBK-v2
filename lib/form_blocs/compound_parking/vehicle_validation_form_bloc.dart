import 'dart:async';
import 'dart:convert';

import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';
import 'package:eo_apk_mbk_v2/helpers/validators.dart';
import 'package:eo_apk_mbk_v2/resources/resources.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class VehicleValidationFormBloc extends FormBloc<String, String> {
  final plateNumber = TextFieldBloc(validators: [InputValidator.required]);

  VehicleValidationFormBloc() {
    addFieldBlocs(fieldBlocs: [plateNumber]);
  }

  @override
  FutureOr<void> onSubmitting() async {
    try {
      String token = await SharedPreferencesHelper.getTokenTM();

      // If token is empty, reload and save it
      if (token.isEmpty) {
        final respondToken = await TrafficManagementResources.reloadToken(
          prefix: 'generate-token',
        );
        token = respondToken['token'];
        await SharedPreferencesHelper.saveTokenTM(token);
      }

      // Button been pushed
      await SharedPreferencesHelper.btnCheckPush(push: true);

      final handHeldId = await SharedPreferencesHelper.getHandheldId();

      final userData = await SharedPreferencesHelper.getLoginCredential();

      final response = await VehicleValidationResource.validateVehicle(
        prefix: '/verify-vehicle',
        body: jsonEncode({
          'OfficerID': userData['id'],
          'DeviceID': handHeldId.toString(),
          'plate_number': plateNumber.value,
        }),
      );

      if (response != null && response is Map<String, dynamic>) {
        final statusDescription = response['statusDescription'];
        final error = response['error'];

        if (statusDescription != null && statusDescription is String) {
          await SharedPreferencesHelper.saveVerifyVehicleDesc(
              statusDescription);

          emitSuccess(successResponse: statusDescription);
        } else if (error != null && error is String) {
          emitFailure(failureResponse: error);
        } else {
          emitFailure(failureResponse: 'Maklumat kenderaan tidak ditemui.');
        }
      } else {
        emitFailure(failureResponse: 'Ralat semasa menghubungi pelayan.');
      }
    } catch (e) {
      emitFailure(failureResponse: 'Check Your Internet Connection.');
    }
  }
}
