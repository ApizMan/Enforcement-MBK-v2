// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:eo_apk_mbk_v2/helpers/compound_print_format.dart';
import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';
import 'package:eo_apk_mbk_v2/routes/route_manager.dart';
import 'package:eo_apk_mbk_v2/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/theme.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:eo_apk_mbk_v2/resources/resources.dart';
import 'package:eo_apk_mbk_v2/widgets/custom_dialog.dart';
import 'package:eo_apk_mbk_v2/widgets/loading_dialog.dart';
import 'package:eo_apk_mbk_v2/src/localization/app_localizations.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class PendingDuplicateScreen extends StatefulWidget {
  final List<List<Map<String, String?>>> dataSets;
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
  final bool isLoading;
  final CompoundResourcesSharedPreferences compoundHelper;
  final Map<String, dynamic> printerMAC;
  final String? qrlink;
  const PendingDuplicateScreen({
    super.key,
    required this.dataSets,
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
    required this.isLoading,
    required this.compoundHelper,
    required this.printerMAC,
    required this.qrlink,
  });

  @override
  State<PendingDuplicateScreen> createState() => _PendingDuplicateScreenState();
}

class _PendingDuplicateScreenState extends State<PendingDuplicateScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _uploadCapturedImages({required String noticeNo}) async {
    final paths =
        await SharedPreferencesHelper.getCapturedImagePathsPending(noticeNo);

    final validPaths = paths.where((path) => path.isNotEmpty).toList();

    List<File> compressedImagesForPahangGo = [];

    for (String? path in validPaths) {
      try {
        final file = File(path!);
        if (!await file.exists()) {
          debugPrint('❌ File not found: $path');
          continue;
        }

        final Uint8List? compressedBytes =
            await FlutterImageCompress.compressWithFile(
          file.path,
          quality: 40,
          minWidth: 720,
          minHeight: 720,
        );

        if (compressedBytes == null) {
          debugPrint('❌ Failed to compress image at $path');
          continue;
        }

        final fileName = path.split('/').last;
        final base64String = base64Encode(compressedBytes);

        final compressedSizeMB = compressedBytes.lengthInBytes / 1024 / 1024;
        final base64SizeMB = base64String.length / 1024 / 1024;

        debugPrint(
            '📦 Compressed size for $fileName: ${compressedSizeMB.toStringAsFixed(2)} MB');
        debugPrint(
            '🧬 Base64 size for $fileName: ${base64SizeMB.toStringAsFixed(2)} MB');

        if (compressedSizeMB > 37.5 || base64SizeMB > 50) {
          debugPrint('⚠️ Skipping $fileName — exceeds limits');
          continue;
        }

        // ✅ Upload to First Server
        final response = await UploadResources.uploadImage(
          prefix: '/compound/upload-image',
          body: {
            'ImageName': fileName,
            'ImageData': base64String,
          },
        );

        final uploadedToFirst = response['StatusCode'] == 'Success';

        if (uploadedToFirst) {
          debugPrint('✅ Uploaded $fileName to first server');

          // Save compressed image to temp file for PahangGo
          final tempPath = '${file.parent.path}/compressed_$fileName';
          final tempFile = await File(tempPath).writeAsBytes(compressedBytes);
          compressedImagesForPahangGo.add(tempFile);
        } else {
          debugPrint(
              '❌ First upload failed for $fileName: ${response['StatusDescription']}');
        }
      } catch (e) {
        debugPrint('❌ Upload failed: $e');
        CustomDialog.show(
          context,
          isDissmissable: false,
          dialogType: DialogType.danger,
          icon: Icons.cloud_off,
          title: "Ralat Internet",
          description: '❌ Upload failed: $e',
          btnOkText: "OK",
          btnOkOnPress: () => Navigator.pop(context),
        );
      }
    }

    // ✅ Upload to PahangGo only if there are valid images
    if (compressedImagesForPahangGo.isNotEmpty) {
      try {
        final respondImagePahangGo = await UploadResources.uploadImagePahangGo(
          prefix: 'compound/pictures',
          compoundNumber: noticeNo,
          pictures: compressedImagesForPahangGo,
        );

        if (respondImagePahangGo['status'] == true) {
          debugPrint('✅ Successfully uploaded to PahangGo');
        } else {
          debugPrint(
              '❌ PahangGo upload failed: ${respondImagePahangGo['message']}');
        }
      } catch (e) {
        debugPrint('❌ PahangGo upload error: $e');
      }
    } else {
      debugPrint('⚠️ No valid images to upload to PahangGo');
    }
  }

  Future<bool> _captureImage({required String noticeNo}) async {
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

    final Uint8List? compressedBytes =
        await FlutterImageCompress.compressWithFile(
      pickedFile.path,
      quality: 40,
      minWidth: 720,
      minHeight: 720,
    );

    if (compressedBytes == null) return false;

    final base64String = base64Encode(compressedBytes);

    final compressedSizeMB = compressedBytes.lengthInBytes / 1024 / 1024;
    final base64SizeMB = base64String.length / 1024 / 1024;

    debugPrint('📦 Compressed size: ${compressedSizeMB.toStringAsFixed(2)} MB');
    debugPrint('🧬 Base64 size: ${base64SizeMB.toStringAsFixed(2)} MB');

    if (compressedSizeMB > 37.5 || base64SizeMB > 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image is too large. Try again.')),
      );
      return false;
    }

    final imageIndex = 'AfterCompound';
    final fileName = '${noticeNo}Pic$imageIndex.jpg';

    final responseUploadImage = await UploadResources.uploadImage(
      prefix: '/compound/upload-image',
      body: {
        'ImageName': fileName,
        'ImageData': base64String,
      },
    );

    if (responseUploadImage['StatusCode'] == "Success") {
      final response = await CompoundResources.updateImageAfter(
        prefix: '/compound/picture-after/$noticeNo',
        body: {'pictureName': fileName},
      );

      // ✅ Upload compressed image to PahangGo
      final tempFilePath =
          '${File(pickedFile.path).parent.path}/compressed_$fileName';
      final compressedFile =
          await File(tempFilePath).writeAsBytes(compressedBytes);

      final pahangGoResponse = await UploadResources.uploadImagePahangGo(
        prefix: 'compound/pictures',
        compoundNumber: noticeNo,
        pictures: [compressedFile],
      );

      if (pahangGoResponse['status'] == true) {
        debugPrint('✅ Uploaded to PahangGo');
      } else {
        debugPrint('❌ PahangGo upload failed: ${pahangGoResponse['message']}');
      }

      return response['success'] == true;
    } else {
      debugPrint(
          '❌ First upload failed: ${responseUploadImage['StatusDescription']}');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: widget.isLoading
          ? const LoadingDialog()
          : Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "${AppLocalizations.of(context)!.pending} ${AppLocalizations.of(context)!.duplicateCopy}",
                        style: textStyleNormal(fontStyle: FontStyle.italic),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                widget.dataSets.isEmpty
                    ? SizedBox.shrink()
                    : Column(
                        children: [
                          spaceVertical(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextField(
                              controller: _searchController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                label: Text(
                                    AppLocalizations.of(context)!.searching),
                                prefixIcon: const Icon(Icons.search,
                                    color: accentCanvasColor),
                                hintText:
                                    '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.noticeNo}',
                                hintStyle:
                                    const TextStyle(color: Colors.black26),
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
                          ),
                        ],
                      ),
                spaceVertical(height: 10.0),
                widget.dataSets.isEmpty
                    ? SizedBox.shrink()
                    : Column(
                        children: [
                          spaceVertical(height: 10.0),
                          PrimaryButton(
                            buttonWidth: 0.9,
                            borderRadius: 10.0,
                            color: accentCanvasColor,
                            onPressed: () async {
                              try {
                                final connectivityResult =
                                    await Connectivity().checkConnectivity();
                                final hasInternet = connectivityResult !=
                                    ConnectivityResult.none;

                                if (!hasInternet) {
                                  CustomDialog.show(
                                    context,
                                    dialogType: DialogType.danger,
                                    isDissmissable: false,
                                    icon: Icons.cloud_off,
                                    title: "Tiada Internet",
                                    description:
                                        "Sila sambungkan ke internet untuk meneruskan.",
                                    btnOkText: "OK",
                                    btnOkOnPress: () => Navigator.pop(context),
                                  );
                                  return;
                                }

                                // ✅ Continue your current logic...
                                final noticePending =
                                    await SharedPreferencesHelper
                                        .getAllOfficerCompoundPendingModels();

                                final noticesWithoutImage = noticePending
                                    .where((notice) =>
                                        notice.imageName5?.isEmpty ?? true)
                                    .toList();

                                if (noticesWithoutImage.isNotEmpty) {
                                  final missingNoticeNos = noticesWithoutImage
                                      .map((e) => e.noticeNo)
                                      .join(',\n');

                                  CustomDialog.show(
                                    context,
                                    dialogType: DialogType.danger,
                                    isDissmissable: false,
                                    icon: Icons.error_rounded,
                                    title:
                                        AppLocalizations.of(context)!.warning,
                                    description:
                                        '${AppLocalizations.of(context)!.warningImage1}:\n$missingNoticeNos\n\n${AppLocalizations.of(context)!.warningImage2}',
                                    btnCancelText:
                                        AppLocalizations.of(context)!.cancel,
                                    btnCancelOnPress: () =>
                                        Navigator.pop(context),
                                    btnOkText: AppLocalizations.of(context)!.ok,
                                    btnOkOnPress: () async {
                                      try {
                                        Navigator.pop(context);
                                        LoadingDialog.show(context);

                                        for (var notice in noticePending) {
                                          await _uploadCompound(
                                              notice, context);
                                        }

                                        LoadingDialog.hide(context);

                                        CustomDialog.show(
                                          context,
                                          dialogType: DialogType.info,
                                          icon: Icons.done,
                                          isDissmissable: false,
                                          title: AppLocalizations.of(context)!
                                              .successUploaded,
                                          description:
                                              AppLocalizations.of(context)!
                                                  .successPushServer,
                                          btnOkText:
                                              AppLocalizations.of(context)!.ok,
                                          btnOkOnPress: () =>
                                              Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            RouteManager.homeScreen,
                                            (route) => false,
                                            arguments: {
                                              'userModel': widget.userModel,
                                              'unitModel': widget.unitModel,
                                              'handHeldId': widget.handHeldId,
                                              'vehicleTypeModel':
                                                  widget.vehicleTypeModel,
                                              'vehicleMakesModel':
                                                  widget.vehicleMakesModel,
                                              'vehicleModelsModel':
                                                  widget.vehicleModelsModel,
                                              'vehicleColorModel':
                                                  widget.vehicleColorModel,
                                              'offenceActModel':
                                                  widget.offenceActModel,
                                              'offenceSectionModel':
                                                  widget.offenceSectionModel,
                                              'offenceAreaModel':
                                                  widget.offenceAreaModel,
                                              'offenceLocationModel':
                                                  widget.offenceLocationModel,
                                            },
                                          ),
                                        );
                                      } catch (e) {
                                        CustomDialog.show(
                                          context,
                                          dialogType: DialogType.danger,
                                          isDissmissable: false,
                                          icon: Icons.cloud_off,
                                          title: "Ralat Internet",
                                          description:
                                              'Please check your internet connection.',
                                          btnOkText: "OK",
                                          btnOkOnPress: () =>
                                              Navigator.pop(context),
                                        );
                                      }
                                    },
                                  );
                                } else {
                                  // If all notices have imageName5
                                  LoadingDialog.show(context);

                                  for (var notice in noticePending) {
                                    await _uploadCompound(notice, context);
                                  }

                                  LoadingDialog.hide(context);

                                  CustomDialog.show(
                                    context,
                                    dialogType: DialogType.info,
                                    isDissmissable: false,
                                    icon: Icons.done,
                                    title: AppLocalizations.of(context)!
                                        .successUploaded,
                                    description: AppLocalizations.of(context)!
                                        .successPushServer,
                                    btnOkText: AppLocalizations.of(context)!.ok,
                                    btnOkOnPress: () =>
                                        Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RouteManager.homeScreen,
                                      (route) => false,
                                      arguments: {
                                        'userModel': widget.userModel,
                                        'unitModel': widget.unitModel,
                                        'handHeldId': widget.handHeldId,
                                        'vehicleTypeModel':
                                            widget.vehicleTypeModel,
                                        'vehicleMakesModel':
                                            widget.vehicleMakesModel,
                                        'vehicleModelsModel':
                                            widget.vehicleModelsModel,
                                        'vehicleColorModel':
                                            widget.vehicleColorModel,
                                        'offenceActModel':
                                            widget.offenceActModel,
                                        'offenceSectionModel':
                                            widget.offenceSectionModel,
                                        'offenceAreaModel':
                                            widget.offenceAreaModel,
                                        'offenceLocationModel':
                                            widget.offenceLocationModel,
                                      },
                                    ),
                                  );
                                }
                              } catch (e) {
                                CustomDialog.show(
                                  context,
                                  dialogType: DialogType.danger,
                                  isDissmissable: false,
                                  icon: Icons.cloud_off,
                                  title: "Ralat Sistem",
                                  description:
                                      'Sila cuba lagi atau hubungi pentadbir.',
                                  btnOkText: "OK",
                                  btnOkOnPress: () => Navigator.pop(context),
                                );
                              }
                            },
                            label: Text(
                              AppLocalizations.of(context)!.resubmit,
                              style:
                                  textStyleNormal(color: kWhite, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                spaceVertical(height: 10.0),
                Expanded(
                  child: widget.dataSets.isEmpty
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.noNewNotice,
                            style: textStyleNormal(
                              fontSize: 14,
                              color: kGrey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: widget.dataSets.length,
                          itemBuilder: (context, index) {
                            final compoundEntry = widget.dataSets[index];
                            final model = widget
                                .compoundHelper.compoundListPending[index];

                            String getValue(String label) {
                              return compoundEntry.firstWhere(
                                    (e) => e['label'] == label,
                                    orElse: () => {'value': ''},
                                  )['value'] ??
                                  '';
                            }

                            final noticeNo =
                                getValue('Notice No').toLowerCase();
                            if (_searchText.isNotEmpty &&
                                !noticeNo.contains(_searchText)) {
                              return const SizedBox.shrink();
                            }

                            return ScaleTap(
                              onPressed: () {
                                CustomDialog.show(
                                  context,
                                  title: AppLocalizations.of(context)!
                                      .duplicateCopy,
                                  isDissmissable: false,
                                  description: getValue('Notice No'),
                                  center: Column(
                                    children: [
                                      _cardDuplicateCopy(
                                        vehicleNo: getValue('Vehicle No'),
                                        roadTaxNo: getValue('Road Tax No'),
                                        brandModel: getValue('Make/Model'),
                                        bodyType: getValue('Vehicle Type'),
                                        color: getValue('Color'),
                                        dateTime: formatOffenceDate(
                                            getValue('Offence Date')),
                                        sectionCode: getSectionDescription(
                                            getValue('Section Code')),
                                        actDescription:
                                            getActDescriptionFromSection(
                                                getValue('Section Code')),
                                        zone: getValue('Area'),
                                        location: getValue('Location'),
                                        locationDetails: getValue('Details'),
                                        notes: getValue('Notes'),
                                        model: model,
                                      ),
                                      PrimaryButton(
                                        buttonWidth: 0.9,
                                        borderRadius: 10.0,
                                        color: accentCanvasColor,
                                        label: Text(
                                          AppLocalizations.of(context)!
                                              .captureImageAfterCompound,
                                          style: textStyleNormal(
                                              color: kWhite, fontSize: 10),
                                        ),
                                        onPressed: () async {
                                          await _uploadCompound(model, context);
                                          final successUploadImageAfter =
                                              await _captureImage(
                                                  noticeNo:
                                                      getValue('Notice No'));

                                          if (successUploadImageAfter) {
                                            CustomDialog.show(
                                              context,
                                              dialogType: DialogType.info,
                                              isDissmissable: false,
                                              icon: Icons.done,
                                              title:
                                                  AppLocalizations.of(context)!
                                                      .successUploaded,
                                              btnOkText:
                                                  AppLocalizations.of(context)!
                                                      .ok,
                                              btnOkOnPress: () => Navigator
                                                  .pushNamedAndRemoveUntil(
                                                context,
                                                RouteManager
                                                    .duplicateCopyParkingScreen,
                                                ModalRoute.withName(RouteManager
                                                    .homeScreen), // 👈 Keep HomeScreen
                                                arguments: {
                                                  'userModel': widget.userModel,
                                                  'unitModel': widget.unitModel,
                                                  'handHeldId':
                                                      widget.handHeldId,
                                                  'vehicleTypeModel':
                                                      widget.vehicleTypeModel,
                                                  'vehicleMakesModel':
                                                      widget.vehicleMakesModel,
                                                  'vehicleModelsModel':
                                                      widget.vehicleModelsModel,
                                                  'vehicleColorModel':
                                                      widget.vehicleColorModel,
                                                  'offenceActModel':
                                                      widget.offenceActModel,
                                                  'offenceSectionModel': widget
                                                      .offenceSectionModel,
                                                  'offenceAreaModel':
                                                      widget.offenceAreaModel,
                                                  'offenceLocationModel': widget
                                                      .offenceLocationModel,
                                                },
                                              ),
                                            );
                                          } else {}
                                        },
                                      ),
                                      spaceVertical(height: 10.0),
                                    ],
                                  ),
                                  btnOkText:
                                      AppLocalizations.of(context)!.print,
                                  btnOkOnPress: () async {
                                    await CompoundPrintService
                                        .connectAndPrintDuplicateCopy(
                                      model: model,
                                      rawMac: widget.printerMAC['printerMAC'],
                                      handHeldId: widget.handHeldId,
                                      userModel: widget.userModel,
                                      unitModel: widget.unitModel,
                                      offenceActModel: widget.offenceActModel,
                                      offenceAreaModel: widget.offenceAreaModel,
                                      offenceLocationModel:
                                          widget.offenceLocationModel,
                                      offenceSectionModel:
                                          widget.offenceSectionModel,
                                      vehicleColorModel:
                                          widget.vehicleColorModel,
                                      vehicleMakesModel:
                                          widget.vehicleMakesModel,
                                      vehicleModelsModel:
                                          widget.vehicleModelsModel,
                                      vehicleTypeModel: widget.vehicleTypeModel,
                                      qr: widget.qrlink ?? '',
                                    );
                                  },
                                  btnCancelText:
                                      AppLocalizations.of(context)!.close,
                                  btnCancelOnPress: () {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: _sectionBoxDecoration(),
                                child: Column(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.noticeNo,
                                      style: textStyleNormal(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: accentCanvasColor,
                                      ),
                                    ),
                                    Text(
                                      getValue('Notice No'),
                                      style: textStyleNormal(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 12,
                                        color: kBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Future<void> _uploadCompound(
      OfficerCompoundModel notice, BuildContext context) async {
    try {
      await _uploadCapturedImages(noticeNo: notice.noticeNo!);

      final officerData = await SharedPreferencesHelper.getLoginCredential();

      final witness = widget.userModel.firstWhere(
        (user) => user.userId == notice.officerSaksi,
        orElse: () => UserModel(), // Or handle null safely
      );

      final witnessName =
          witness.fullName; // assuming UserModel has a `.name` field

      final now = DateTime(2025, 6, 19, 14, 30, 0);
      final formatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      final idByNoticeNo =
          await SharedPreferencesHelper.getIdsByNoticeNo(notice.noticeNo!);

      final responsePahangGo = await UploadResources.uploadCompoundToPahangGo(
          prefix: 'compound/parking',
          body: {
            'compound_number': notice.noticeNo,
            'act_id': idByNoticeNo!['act_id'],
            'offence_id': idByNoticeNo['offence_id'],
            'area_id': idByNoticeNo['area_id'],
            'zone_id': idByNoticeNo['zone_id'],
            'vehicle_type': notice.vehicleType,
            'vehicle_model': notice.vehicleMakeModel,
            'color': notice.vehicleColor,
            'plate_number': notice.vehicleNo,
            'road_tax_number': notice.roadTaxNo,
            'parking_lot_number': notice.squarePoleNo,
            'street_name': notice.offenceArea,
            'offence_location': notice.offenceLocation,
            'offence_datetime':
                formatOffenceDatePahangGo(notice.offenceDateString!),
            'witness_code': notice.officerSaksi,
            'witness_name': witnessName,
            'enforcer_code': notice.officerId,
            'enforcer_name': officerData['name'],
            'status': 0,
            'status_time': formatted,
          });

      if (responsePahangGo['status'] == true) {
        final responseEnforcementCCP =
            await UploadResources.uploadCompoundToEnforcementCCP(
                prefix: '/compound/upload',
                body: {
              'NoticeNo': notice.noticeNo.toString(),
              'VehicleNo': notice.vehicleNo.toString(),
              'OfficerID': notice.officerId.toString(),
              'OfficerUnit': notice.officerUnit.toString(),
              'HandheldCode': notice.handheldCode.toString(),
              'OffenceDateString': notice.offenceDateString.toString(),
              'VehicleType': notice.vehicleType.toString(),
              'VehicleColor': notice.vehicleColor.toString(),
              'VehicleMakeModel': notice.vehicleMakeModel.toString(),
              'RoadTaxNo': notice.roadTaxNo.toString(),
              'OffenceSectionCode': notice.offenceSectionCode.toString(),
              'OffenceArea': notice.offenceArea.toString(),
              'OffenceLocation': notice.offenceLocation.toString(),
              'OffenceLocationDetails':
                  notice.offenceLocationDetails.toString(),
              'SquarePoleNo': notice.squarePoleNo.toString(),
              'ImageName1': notice.imageName1.toString(),
              'ImageName2': notice.imageName2.toString(),
              'ImageName3': notice.imageName3.toString(),
              'ImageName4': notice.imageName4.toString(),
              'ImageName5': notice.imageName5.toString(),
              'IsClamping': notice.isClamping,
              'Notes': notice.notes.toString(),
              'Latitude': notice.latitude,
              'Longitude': notice.longitude,
              'CompoundAmount': notice.compoundAmount,
              'OfficerSaksi': notice.officerSaksi.toString(),
            });

        if (responseEnforcementCCP['StatusCode'] == 'Success') {
          await SharedPreferencesHelper.saveOfficerCompoundModel(notice);

          await SharedPreferencesHelper.removeOfficerCompoundPendingByNoticeNo(
              notice.noticeNo!);

          await SharedPreferencesHelper.clearCapturedImagePathsPending(
              notice.noticeNo!);
        } else {
          CustomDialog.show(
            context,
            dialogType: DialogType.danger,
            isDissmissable: false,
            icon: Icons.warning,
            title: AppLocalizations.of(context)!.warning,
            description: responseEnforcementCCP['StatusDescription'],
            btnOkText: AppLocalizations.of(context)!.ok,
            btnOkOnPress: () => Navigator.pop(context),
          );
        }
      } else {
        CustomDialog.show(
          context,
          dialogType: DialogType.danger,
          isDissmissable: false,
          icon: Icons.warning,
          title: AppLocalizations.of(context)!.warning,
          description: responsePahangGo['message'] ??
              'Failed to upload compound to Pahang Go.',
          btnOkText: AppLocalizations.of(context)!.ok,
          btnOkOnPress: () => Navigator.pop(context),
        );
      }
    } catch (e) {
      CustomDialog.show(
        context,
        dialogType: DialogType.danger,
        isDissmissable: false,
        icon: Icons.cloud_off,
        title: "Ralat Internet",
        description: 'Error: $e',
        btnOkText: "OK",
        btnOkOnPress: () => Navigator.pop(context),
      );
    }
  }

  BoxDecoration _sectionBoxDecoration() {
    return BoxDecoration(
      color: kWhite,
      border: Border.all(color: accentCanvasColor),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );
  }

  String getSectionDescription(String? sectionId) {
    final section = widget.offenceSectionModel.firstWhere(
      (s) => s.id.toString() == sectionId,
      orElse: () => OffenceSectionModel(id: '', description: ''),
    );
    return section.description ?? '';
  }

  String getActDescriptionFromSection(String? sectionId) {
    final section = widget.offenceSectionModel.firstWhere(
      (s) => s.id.toString() == sectionId,
      orElse: () => OffenceSectionModel(id: '', description: '', actId: ''),
    );

    final act = widget.offenceActModel.firstWhere(
      (a) => a.id == section.actId,
      orElse: () => OffenceActModel(id: '', description: ''),
    );

    return act.description ?? '';
  }

  Widget _twoColumnRow(
    String label1,
    String label2,
    String value1,
    String value2,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label1,
                style: textStyleNormal(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: kBlack,
                ),
              ),
            ),
            Expanded(
              child: Text(
                label2,
                style: textStyleNormal(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: kBlack,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                value1,
                style: textStyleNormal(
                    color: accentCanvasColor, fontStyle: FontStyle.italic),
              ),
            ),
            Expanded(
              child: Text(
                value2,
                style: textStyleNormal(
                    color: accentCanvasColor, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _oneColumn(
    String label1,
    String value1,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label1,
          style: textStyleNormal(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: kBlack,
          ),
        ),
        Text(
          value1,
          style: textStyleNormal(
              color: accentCanvasColor, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _imageRowPreview({required OfficerCompoundModel model}) {
    final imageNames = [
      model.imageName1,
      model.imageName2,
      model.imageName3,
      model.imageName4,
      model.imageName5,
    ];

    const imageDirPath =
        '/storage/emulated/0/Download/Pictures/CompoundImages/';

    final validImages = imageNames
        .where((name) => name != null && name.isNotEmpty)
        .map((name) => File('$imageDirPath$name'))
        .toList();

    return validImages.isEmpty
        ? Text(
            'No images available.',
            style: textStyleNormal(fontStyle: FontStyle.italic),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: validImages.map((file) {
                return Container(
                  margin: const EdgeInsets.only(right: 8.0, top: 10),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.file(
                    file,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Center(child: Icon(Icons.broken_image)),
                  ),
                );
              }).toList(),
            ),
          );
  }

  Widget _cardDuplicateCopy({
    required String vehicleNo,
    required String roadTaxNo,
    required String brandModel,
    required String bodyType,
    required String color,
    required String dateTime,
    required String sectionCode,
    required String actDescription,
    required String zone,
    required String location,
    required String locationDetails,
    required String notes,
    required OfficerCompoundModel model,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _twoColumnRow(
            AppLocalizations.of(context)!.vehicleNumber,
            AppLocalizations.of(context)!.taxRoadNumber,
            vehicleNo,
            roadTaxNo,
          ),
          spaceVertical(height: 10.0),
          _oneColumn(
            '${AppLocalizations.of(context)!.brands} / ${AppLocalizations.of(context)!.model}',
            brandModel,
          ),
          spaceVertical(height: 10.0),
          _twoColumnRow(
            AppLocalizations.of(context)!.bodyType,
            AppLocalizations.of(context)!.color,
            bodyType,
            color,
          ),
          spaceVertical(height: 10.0),
          _oneColumn(
            AppLocalizations.of(context)!.dateAndTime,
            dateTime,
          ),
          spaceVertical(height: 10.0),
          Text(
            AppLocalizations.of(context)!.images,
            style: textStyleNormal(
              color: accentCanvasColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Add image preview here if needed
          _imageRowPreview(model: model),
          spaceVertical(height: 10.0),
          _oneColumn(
            AppLocalizations.of(context)!.legalProvisions,
            actDescription,
          ),
          spaceVertical(height: 10.0),
          _oneColumn(
            AppLocalizations.of(context)!.sectionOrOrderOrMethod,
            sectionCode,
          ),
          spaceVertical(height: 10.0),
          _oneColumn(
            AppLocalizations.of(context)!.zone,
            zone,
          ),
          spaceVertical(height: 10.0),
          _oneColumn(
            AppLocalizations.of(context)!.placement,
            location,
          ),
          spaceVertical(height: 10.0),
          _oneColumn(
            AppLocalizations.of(context)!.locationDetail,
            locationDetails,
          ),
          spaceVertical(height: 10.0),
          _oneColumn(
            AppLocalizations.of(context)!.notes,
            notes,
          ),
        ],
      ),
    );
  }
}
