// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
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
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:eo_apk_mbk_v2/helpers/validation_form.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<bool> _captureImage() async {
    final cameraStatus = await Permission.camera.request();
    PermissionStatus storageStatus;

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      int sdkInt = deviceInfo.version.sdkInt;
      storageStatus = sdkInt >= 33
          ? await Permission.photos.request()
          : await Permission.storage.request();
    } else {
      storageStatus = await Permission.photos.request();
    }

    if (!cameraStatus.isGranted || !storageStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Camera or photo access permission denied')),
      );
      return false;
    }

    // 📸 Retry loop until image is captured
    XFile? pickedFile;
    while (pickedFile == null) {
      pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedFile == null) {
        final retry = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('Image Required'),
            content: const Text('You must capture an image to proceed.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Retry'),
              ),
            ],
          ),
        );

        if (retry != true) return false;
      }
    }

    // 📦 Compress the image
    final Uint8List? compressedBytes =
        await FlutterImageCompress.compressWithFile(
      pickedFile.path,
      quality: 60, // reduced quality
      minWidth: 720, // resize width
      minHeight: 720, // resize height
    );

    if (compressedBytes == null) return false;

    final base64String = base64Encode(compressedBytes);
    final compressedSizeMB = compressedBytes.lengthInBytes / 1024 / 1024;
    final base64SizeMB = base64String.length / 1024 / 1024;

    debugPrint('📦 Compressed size: ${compressedSizeMB.toStringAsFixed(2)} MB');
    debugPrint('🧬 Base64 size: ${base64SizeMB.toStringAsFixed(2)} MB');

    // 🚫 Skip if image too large
    if (compressedSizeMB > 37.5 || base64SizeMB > 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image is too large. Please try again.')),
      );
      return false;
    }

    // 🏷️ Prepare image name
    final handheldCode = await SharedPreferencesHelper.getHandheldId();
    final year = DateTime.now().year.toString().substring(2);
    int serial = await SharedPreferencesHelper.getNoticeSerialNumber();
    final previousSerial = serial - 1;
    final paddedSerial = previousSerial.toString().padLeft(5, '0');
    final imageIndex = 'AfterCompound';
    final fileName = '$handheldCode$year${paddedSerial}Pic$imageIndex.jpg';

    // ☁️ Upload image
    final responseUploadImage = await UploadResources.uploadImage(
      prefix: '/compound/upload-image',
      body: {
        'ImageName': fileName,
        'ImageData': base64String,
      },
    );

    final compoundName = '$handheldCode$year$paddedSerial';

    if (responseUploadImage['StatusCode'] == "Success") {
      final response = await CompoundResources.updateImageAfter(
        prefix: '/compound/picture-after/$compoundName',
        body: {
          'pictureName': fileName,
        },
      );

      return response['success'] == true;
    } else {
      debugPrint(
          '❌ Upload failed: ${responseUploadImage['StatusDescription']}');
      return false;
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
                unitModel: unitModel,
                userModel: userModel,
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

                  if (state.failureResponse != null) {
                    CustomDialog.show(
                      context,
                      dialogType: DialogType.danger,
                      isDissmissable: false,
                      icon: Icons.warning,
                      title: AppLocalizations.of(context)!.warning,
                      description: state.failureResponse,
                      btnOkText: AppLocalizations.of(context)!.ok,
                      btnOkOnPress: () => Navigator.pop(context),
                    );
                  }
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
                  onSuccess: (context, state) async {
                    LoadingDialog.hide(context);
                    final uploadImageBeforeCompound =
                        await _uploadCapturedImages(); // ✅ Only upload if form is valid

                    if (uploadImageBeforeCompound) {
                      final captureAfterCompound = await _captureImage();

                      if (captureAfterCompound) {
                        CustomDialog.show(
                          context,
                          dialogType: DialogType.info,
                          isDissmissable: false,
                          icon: Icons.done,
                          title:
                              AppLocalizations.of(context)!.compoundSuccessDesc,
                          description: '',
                          btnOkText: AppLocalizations.of(context)!.ok,
                          btnOkOnPress: () => Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouteManager.homeScreen,
                            (route) => false,
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
                            },
                          ),
                        );
                      } else {
                        CustomDialog.show(
                          context,
                          dialogType: DialogType.danger,
                          icon: Icons.warning,
                          isDissmissable: false,
                          title: AppLocalizations.of(context)!.warning,
                          description: 'Error Upload Image After Compound',
                          btnOkText: AppLocalizations.of(context)!.ok,
                          btnOkOnPress: () => Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouteManager.homeScreen,
                            (route) => false,
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
                            },
                          ),
                        );
                      }
                    } else {
                      CustomDialog.show(
                        context,
                        dialogType: DialogType.danger,
                        icon: Icons.warning,
                        isDissmissable: false,
                        title: AppLocalizations.of(context)!.warning,
                        description: 'Error Upload Image Before Compound',
                        btnOkText: AppLocalizations.of(context)!.ok,
                        btnOkOnPress: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          RouteManager.homeScreen,
                          (route) => false,
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
                          },
                        ),
                      );
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.successResponse!)),
                    );
                  },
                  onFailure: (context, state) {
                    LoadingDialog.hide(context);

                    final failure = state.failureResponse;

                    if (failure != null) {
                      try {
                        final decoded = jsonDecode(failure);
                        final type = decoded['type'];
                        final message = decoded['message'];

                        switch (type) {
                          case 'validation':
                            CustomDialog.show(
                              context,
                              dialogType: DialogType.danger,
                              isDissmissable: false,
                              icon: Icons.warning,
                              title: AppLocalizations.of(context)!.warning,
                              description: message,
                              btnOkText: AppLocalizations.of(context)!.ok,
                              btnOkOnPress: () => Navigator.pop(context),
                            );
                            break;

                          case 'duplicate':
                            CustomDialog.show(
                              context,
                              dialogType: DialogType.danger,
                              isDissmissable: false,
                              icon: Icons.copy,
                              title: "Salinan Duplikasi",
                              description: message,
                              btnOkText: "Faham",
                              btnOkOnPress: () =>
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      RouteManager.homeScreen, (route) => false,
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
                                    'offenceLocationModel':
                                        offenceLocationModel,
                                  }),
                            );
                            break;

                          case 'network':
                            CustomDialog.show(
                              context,
                              dialogType: DialogType.danger,
                              isDissmissable: false,
                              icon: Icons.cloud_off,
                              title: "Ralat Internet",
                              description: message,
                              btnOkText: "OK",
                              btnOkOnPress: () =>
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      RouteManager.homeScreen, (route) => false,
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
                                    'offenceLocationModel':
                                        offenceLocationModel,
                                  }),
                            );
                            break;

                          case 'print':
                            CustomDialog.show(
                              context,
                              dialogType: DialogType.danger,
                              isDissmissable: false,
                              icon: Icons.print,
                              title: "Ralat Cetak",
                              description: message,
                              btnOkText: "OK",
                              btnOkOnPress: () =>
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      RouteManager.homeScreen, (route) => false,
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
                                    'offenceLocationModel':
                                        offenceLocationModel,
                                  }),
                            );
                            break;

                          case 'connectionPrinter':
                            CustomDialog.show(
                              context,
                              dialogType: DialogType.danger,
                              isDissmissable: false,
                              icon: Icons.print,
                              title: "Ralat Printer",
                              description: message,
                              btnOkText: "OK",
                              btnOkOnPress: () => Navigator.popAndPushNamed(
                                context,
                                RouteManager.settingScreen,
                                arguments: {
                                  'handHeldId': handHeldId,
                                },
                              ),
                            );
                            break;

                          default:
                            CustomDialog.show(
                              context,
                              dialogType: DialogType.danger,
                              isDissmissable: false,
                              icon: Icons.warning,
                              title: AppLocalizations.of(context)!.warning,
                              description: message,
                              btnOkText: AppLocalizations.of(context)!.ok,
                              btnOkOnPress: () => Navigator.pop(context),
                            );
                        }
                      } catch (_) {
                        // fallback if response is not JSON
                        CustomDialog.show(
                          context,
                          dialogType: DialogType.danger,
                          isDissmissable: false,
                          icon: Icons.warning,
                          title: AppLocalizations.of(context)!.warning,
                          description: failure,
                          btnOkText: AppLocalizations.of(context)!.ok,
                          btnOkOnPress: () => Navigator.pop(context),
                        );
                      }
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
                        tabItems: [
                          Tab(icon: Icon(Icons.directions_car)),
                          Tab(icon: Icon(Icons.warning_rounded)),
                          Tab(icon: Icon(Icons.insert_drive_file_rounded)),
                        ],
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
      isDissmissable: false,
      icon: Icons.warning,
      title: AppLocalizations.of(context)!.warning,
      description: message,
      btnOkText: AppLocalizations.of(context)!.ok,
      btnOkOnPress: () => Navigator.pop(context),
    );
  }

  Future<bool> _uploadCapturedImages() async {
    final paths = await SharedPreferencesHelper.getCapturedImagePaths();

    // Filter non-null and non-empty paths
    final validPaths =
        paths.whereType<String>().where((path) => path.isNotEmpty).toList();

    bool hasSuccess = false;

    for (final path in validPaths) {
      try {
        final file = File(path);
        if (!await file.exists()) {
          debugPrint('❌ File not found: $path');
          continue;
        }

        // ✅ Compress image
        final Uint8List? compressedBytes =
            await FlutterImageCompress.compressWithFile(
          file.path,
          quality: 60,
          minWidth: 720,
          minHeight: 720,
        );

        if (compressedBytes == null) {
          debugPrint('❌ Failed to compress: $path');
          continue;
        }

        final base64String = base64Encode(compressedBytes);
        final compressedSizeMB = compressedBytes.lengthInBytes / 1024 / 1024;
        final base64SizeMB = base64String.length / 1024 / 1024;

        debugPrint(
            '📦 Compressed size: ${compressedSizeMB.toStringAsFixed(2)} MB');
        debugPrint('🧬 Base64 size: ${base64SizeMB.toStringAsFixed(2)} MB');

        // 🚫 Skip if image too large
        if (compressedSizeMB > 37.5 || base64SizeMB > 50) {
          debugPrint('⚠️ Skipping $path — exceeds upload size limit');
          continue;
        }

        final fileName = path.split('/').last;
        final response = await UploadResources.uploadImage(
          prefix: '/compound/upload-image',
          body: {
            'ImageName': fileName,
            'ImageData': base64String,
          },
        );

        if (response['StatusCode'] == "Success") {
          debugPrint('✅ Uploaded $fileName successfully');
          hasSuccess = true;
        } else {
          debugPrint('❌ Failed to upload $fileName');
          debugPrint('🛑 Server response: ${response['StatusDescription']}');
        }
      } catch (e) {
        debugPrint('❌ Exception while processing $path: $e');
      }
    }

    return hasSuccess;
  }
}
