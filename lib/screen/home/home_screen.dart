// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:eo_apk_mbk_v2/controllers/home_controller.dart';
import 'package:eo_apk_mbk_v2/form_blocs/form_bloc.dart';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:eo_apk_mbk_v2/resources/resources.dart';
import 'package:eo_apk_mbk_v2/routes/route_manager.dart';
import 'package:eo_apk_mbk_v2/screen/screen.dart';
import 'package:eo_apk_mbk_v2/widgets/custom_dialog.dart';
import 'package:eo_apk_mbk_v2/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:eo_apk_mbk_v2/helpers/validation_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller =
      Get.find<HomeController>(); // ✅ Use this only if needed

  bool _isInitialized = false;
  List<UserModel> userModel = [];
  List<OfficerUnitModel> unitModel = [];
  late String handHeldId;
  List<VehicleTypeModel> vehicleTypeModel = [];
  List<VehicleBrandModel> vehicleMakesModel = [];
  List<VehicleModelsModel> vehicleModelsModel = [];
  List<VehicleColorModel> vehicleColorModel = [];
  List<OffenceActModel> offenceActModel = [];
  List<OffenceSectionModel> offenceSectionModel = [];
  List<OffenceAreaModel> offenceAreaModel = [];
  List<OffenceLocationModel> offenceLocationModel = [];

  // FormBloc
  VehicleValidationFormBloc? vehicleValidationFormBloc;
  CompoundParkingFormBloc? compoundParkingFormBloc;

  @override
  void initState() {
    handHeldId = "";
    super.initState();

    Future.delayed(Duration.zero, () {
      controller.setScreen(RouteManager.compoundParkingBody);
      _resetPushBtnStatus();
      _resetAfterCompound();
    });
  }

  Future<void> _resetPushBtnStatus() async {
    await SharedPreferencesHelper.btnCheckPush(push: false);
  }

  Future<void> _resetAfterCompound() async {
    await SharedPreferencesHelper.clearCapturedImagePaths();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (arguments != null) {
        userModel = arguments['userModel'] as List<UserModel>;
        unitModel = arguments['unitModel'] as List<OfficerUnitModel>;
        handHeldId = arguments['handHeldId'] as String;
        vehicleTypeModel =
            arguments['vehicleTypeModel'] as List<VehicleTypeModel>;
        vehicleMakesModel =
            arguments['vehicleMakesModel'] as List<VehicleBrandModel>;
        vehicleModelsModel =
            arguments['vehicleModelsModel'] as List<VehicleModelsModel>;
        vehicleColorModel =
            arguments['vehicleColorModel'] as List<VehicleColorModel>;
        offenceActModel = arguments['offenceActModel'] as List<OffenceActModel>;
        offenceSectionModel =
            arguments['offenceSectionModel'] as List<OffenceSectionModel>;
        offenceAreaModel =
            arguments['offenceAreaModel'] as List<OffenceAreaModel>;
        offenceLocationModel =
            arguments['offenceLocationModel'] as List<OffenceLocationModel>;
      }
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isCompoundParking =
          controller.currentScreen.value == RouteManager.compoundParkingBody;

      return DefaultTabController(
        length: 3,
        child: MultiBlocProvider(
          providers: [
            // Validation Plate Number
            BlocProvider<VehicleValidationFormBloc>(
              create: (context) => VehicleValidationFormBloc(),
            ),

            // Finalize
            BlocProvider<CompoundParkingFormBloc>(
              create: (context) => CompoundParkingFormBloc(
                vehicleTypeModel: vehicleTypeModel,
                vehicleMakesModel: vehicleMakesModel,
                vehicleModelsModel: vehicleModelsModel,
                vehicleColorModel: vehicleColorModel,
                offenceActModel: offenceActModel,
                offenceSectionModel: offenceSectionModel,
                offenceAreaModel: offenceAreaModel,
                offenceLocationModel: offenceLocationModel,
                vehicleValidationFormBloc: vehicleValidationFormBloc!,
              ),
            ),
            BlocProvider<CompoundAmFormBloc>(
              create: (context) => CompoundAmFormBloc(),
            ),
          ],
          child: Builder(
            builder: (context) {
              // Validation Plate Number
              vehicleValidationFormBloc =
                  BlocProvider.of<VehicleValidationFormBloc>(context);

              // Finalize
              compoundParkingFormBloc =
                  BlocProvider.of<CompoundParkingFormBloc>(context);
              final compoundAmFormBloc = BlocProvider.of<CompoundAmFormBloc>(
                context,
              );

              return FormBlocListener<VehicleValidationFormBloc, String,
                  String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSubmissionFailed: (context, state) =>
                    LoadingDialog.hide(context),
                onSuccess: (context, state) async {
                  LoadingDialog.hide(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.successResponse!)),
                  );
                },
                onFailure: (context, state) {
                  LoadingDialog.hide(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.failureResponse!)),
                  );
                },
                child:
                    FormBlocListener<CompoundParkingFormBloc, String, String>(
                  onSubmitting: (context, state) {
                    LoadingDialog.show(context);
                  },
                  onSubmissionFailed: (context, state) async {
                    LoadingDialog.hide(context);

                    final bloc = compoundParkingFormBloc!;
                    final vehicleBloc = vehicleValidationFormBloc!;
                    final btnPush =
                        await SharedPreferencesHelper.getCheckPush();

                    final error =
                        await validateForm(bloc, vehicleBloc, btnPush);

                    switch (error) {
                      case ValidationForm.missingPlate:
                        return showWarning(
                            context, "Sila Isikan Nombor Kenderaan.");
                      case ValidationForm.notPushed:
                        return showWarning(context, "Sila Tekan Button Semak.");
                      case ValidationForm.missingBrand:
                        return showWarning(
                            context, "Sila Pilih Jenama Kenderaan.");
                      case ValidationForm.missingModel:
                        return showWarning(
                            context, "Sila Pilih Model Kenderaan.");
                      case ValidationForm.missingType:
                        return showWarning(
                            context, "Sila Pilih Jenis Badan Kenderaan.");
                      case ValidationForm.missingColor:
                        return showWarning(
                            context, "Sila Pilih Warna Kenderaan.");
                      case ValidationForm.missingActLaw:
                        return showWarning(
                            context, "Sila Pilih Peruntukan Undang-Undang.");
                      case ValidationForm.missingSection:
                        return showWarning(
                            context, "Sila Pilih Seksyen/Kaedah.");
                      case ValidationForm.missingArea:
                        return showWarning(context, "Sila Pilih Nama Zon.");
                      case ValidationForm.missingPlacement:
                        return showWarning(context, "Sila Pilih Nama Jalan.");
                      case ValidationForm.missingImages:
                        return showWarning(
                            context, "Sila ambil sekurang-kurangnya 2 gambar.");
                      case ValidationForm.none:
                        return;
                    }
                  },
                  onSuccess: (context, state) {
                    LoadingDialog.hide(context);
                    setState(() {
                      _uploadCapturedImages(); // ✅ Only upload if form is valid
                    });
                    Navigator.popAndPushNamed(context, RouteManager.homeScreen,
                        arguments: {
                          'userModel': userModel,
                          'unitModel': unitModel,
                          'handHeldId': handHeldId,
                          'vehicleTypeModel': vehicleTypeModel,
                          'vehicleMakesModel': vehicleMakesModel,
                          'vehicleModelsModel': vehicleModelsModel,
                          'vehicleColorModel': vehicleColorModel,
                          'offenceActModel': offenceActModel,
                          'offenceSectionModel': offenceSectionModel,
                          'offenceAreaModel': offenceAreaModel,
                          'offenceLocationModel': offenceLocationModel,
                        });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.successResponse!)),
                    );
                  },
                  onFailure: (context, state) {
                    LoadingDialog.hide(context);

                    if (state.failureResponse != null) {
                      CustomDialog.show(
                        context,
                        dialogType: DialogType.danger,
                        icon: Icons.warning,
                        title: AppLocalizations.of(context)!.warning,
                        description: state.failureResponse,
                        btnOkText: AppLocalizations.of(context)!.ok,
                        btnOkOnPress: () => Navigator.pop(context),
                      );
                    }
                  },
                  child: FormBlocListener<CompoundAmFormBloc, String, String>(
                    onSubmitting: (context, state) {
                      LoadingDialog.show(context);
                    },
                    onSubmissionFailed: (context, state) =>
                        LoadingDialog.hide(context),
                    onSuccess: (context, state) {
                      LoadingDialog.hide(context);
                      Navigator.popAndPushNamed(
                        context,
                        RouteManager.homeScreen,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.successResponse!)),
                      );
                    },
                    onFailure: (context, state) {
                      LoadingDialog.hide(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.failureResponse!)),
                      );
                    },
                    child: Scaffold(
                      backgroundColor: const Color.fromRGBO(249, 246, 246, 1),
                      appBar: HeaderLayout(
                        bottomSize: isCompoundParking
                            ? hasBottomAppBarSize
                            : noBottomAppBarSize,
                        title: AppLocalizations.of(context)!.handHeldMBK,
                        showTabBar: isCompoundParking,
                        compoundParkingFormBloc: compoundParkingFormBloc,
                        compoundAmFormBloc: compoundAmFormBloc,
                      ),
                      drawer: SidebarLayout(
                        userModel: userModel,
                        unitModel: unitModel,
                        handHeldId: handHeldId,
                        offenceActModel: offenceActModel,
                        offenceAreaModel: offenceAreaModel,
                        offenceLocationModel: offenceLocationModel,
                        offenceSectionModel: offenceSectionModel,
                        vehicleColorModel: vehicleColorModel,
                        vehicleMakesModel: vehicleMakesModel,
                        vehicleModelsModel: vehicleModelsModel,
                        vehicleTypeModel: vehicleTypeModel,
                      ),
                      body: isCompoundParking
                          ? CompoundParkingScreen(
                              compoundParkingFormBloc: compoundParkingFormBloc,
                              vehicleValidationFormBloc:
                                  vehicleValidationFormBloc,
                            )
                          : CompoundAmScreen(
                              compoundAmFormBloc: compoundAmFormBloc,
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  Future<void> showWarning(BuildContext context, String message) {
    return CustomDialog.show(
      context,
      dialogType: DialogType.danger,
      icon: Icons.warning,
      title: AppLocalizations.of(context)!.warning,
      description: message,
      btnOkText: AppLocalizations.of(context)!.ok,
      btnOkOnPress: () => Navigator.pop(context),
    );
  }

  Future<void> _uploadCapturedImages() async {
    final paths = await SharedPreferencesHelper.getCapturedImagePaths();

    // Filter non-null and existing paths
    final validPaths =
        paths.where((path) => path != null && path.isNotEmpty).toList();

    for (String? path in validPaths) {
      final file = File(path!);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        final base64String = base64Encode(bytes);
        final fileName = path.split('/').last;

        final response = await UploadResources.uploadImage(
          prefix: '/UploadImageString',
          body: {
            'ImageName': fileName,
            'ImageData': base64String,
          },
        );

        if (response['StatusDescription'] == null) {
          final responseEnYasin = await UploadResources.uploadImageEnYasin(
            prefix: '/UploadImageString',
            body: {
              'ImageName': fileName,
              'ImageData': base64String,
            },
          );

          if (responseEnYasin['StatusCode'] == null) {
            debugPrint('✅ Uploaded $fileName successfully');
          } else {
            debugPrint('❌ Failed to upload $fileName to EnYasin');
            debugPrint('Response: ${responseEnYasin['StatusDescription']}');
            break; // Optional: Stop further uploads
          }
        } else {
          debugPrint('❌ Failed to upload $fileName');
          debugPrint('Response: ${response.body}');
          break;
        }
      }
    }
  }
}
