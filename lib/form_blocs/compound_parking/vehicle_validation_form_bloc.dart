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
    String token = await SharedPreferencesHelper.getTokenTM();

    // If token is empty, reload and save it
    if (token.isEmpty) {
      final respondToken = await TrafficManagementResources.reloadToken(
        prefix: 'generate-token',
      );
      token = respondToken['token'];
      await SharedPreferencesHelper.saveTokenTM(token);
    }

    final respondTM =
        await VehicleValidationResource.validateVehicleTrafficManagement(
      prefix: 'verify-vehicle',
      token: token,
      body: jsonEncode({'plate_number': plateNumber.value}),
    );

    // Button been pushed
    await SharedPreferencesHelper.btnCheckPush(push: true);

    if (respondTM['success'] == true &&
        respondTM['data'] is List &&
        respondTM['data'].isNotEmpty) {
      final data = respondTM['data'][0];
      emitSuccess(
        successResponse:
            'Berbayar - ${data['plate_number']} (${data['end_date']} ${data['end_time']})',
      );
    } else {
      final respondEnYasin =
          await VehicleValidationResource.validateVehicleEnYasin(
        prefix: 'verify-vehicle-en-yasin',
        body: jsonEncode({'plate': plateNumber.value}),
      );

      if (respondEnYasin is List && respondEnYasin.isNotEmpty) {
        final data = respondEnYasin.first;

        emitSuccess(
          successResponse:
              'Berbayar - ${data['plate']} (${data['enddate']} ${data['endtime']})',
        );
      } else {
        emitFailure(failureResponse: 'Tidak Berbayar');
      }
    }
  }
}
