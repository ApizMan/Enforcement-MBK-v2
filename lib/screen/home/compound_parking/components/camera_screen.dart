// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:eo_apk_mbk_v2/form_blocs/form_bloc.dart';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';
import 'package:eo_apk_mbk_v2/helpers/theme.dart';
import 'package:eo_apk_mbk_v2/screen/screen.dart';
import 'package:eo_apk_mbk_v2/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_media_delete/flutter_media_delete.dart';
import 'package:flutter_media_store/flutter_media_store.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<File?> capturedImages = List.generate(4, (index) => null);
  List<String?> savedImagePaths = List.generate(4, (index) => null);
  bool _isInitialized = false;
  CompoundParkingFormBloc? formBloc;
  int? serialNumber;
  int? imageCount;

  @override
  void initState() {
    super.initState();
    _loadSavedImages();
    _getSerialNumberCompaund();
  }

  Future<void> _loadSavedImages() async {
    List<String?> paths = await SharedPreferencesHelper.getCapturedImagePaths();
    List<File?> images = List.generate(4, (index) {
      final path = index < paths.length ? paths[index] : null;
      return path != null ? File(path) : null;
    });

    setState(() {
      savedImagePaths = paths;
      capturedImages = images;
    });
  }

  Future<void> _getSerialNumberCompaund() async {
    final serial = await SharedPreferencesHelper.getNoticeSerialNumber();
    final images = await SharedPreferencesHelper.getImageCount();
    setState(() {
      serialNumber = serial;
      imageCount = images;
    });
  }

  Future<void> _captureImage() async {
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
      return;
    }

    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    final Uint8List? compressedBytes =
        await FlutterImageCompress.compressWithFile(
      pickedFile.path,
      quality: 70,
    );

    if (compressedBytes == null) return;

    final File previewFile = File(pickedFile.path);
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm photo?'),
        content: Image.file(previewFile),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Retry')),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Confirm')),
        ],
      ),
    );

    if (confirm != true) {
      _captureImage(); // retry
      return;
    }

    final handheldCode = await SharedPreferencesHelper.getHandheldId();
    final year = DateTime.now().year.toString();
    final paddedSerial = (await SharedPreferencesHelper.getNoticeSerialNumber())
        .toString()
        .padLeft(5, '0');
    final imageIndex = capturedImages.indexWhere((img) => img == null);
    final fileName = '$handheldCode$year${paddedSerial}Pic$imageIndex.jpg';

    // Save to MediaStore
    final flutterMediaStore = FlutterMediaStore();

    await flutterMediaStore.saveFile(
      fileData: compressedBytes,
      mimeType: 'image/jpeg',
      rootFolderName: 'Pictures',
      folderName: 'CompoundImages',
      fileName: fileName,
      onSuccess: (String uri, String filePath) async {
        debugPrint('Image saved to: $filePath');

        setState(() {
          capturedImages[imageIndex] = File(filePath);
          savedImagePaths[imageIndex] = filePath;
        });

        await SharedPreferencesHelper.setCapturedImagePaths(savedImagePaths);

        switch (imageIndex) {
          case 0:
            formBloc?.imageName1.updateValue(fileName);
            break;
          case 1:
            formBloc?.imageName2.updateValue(fileName);
            break;
          case 2:
            formBloc?.imageName3.updateValue(fileName);
            break;
          case 3:
            formBloc?.imageName4.updateValue(fileName);
            break;
        }

        final newCount = (imageCount ?? 0) + 1;
        await SharedPreferencesHelper.saveImageCount(newCount);
        setState(() {
          imageCount = newCount;
        });
      },
      onError: (String errorMessage) {
        debugPrint('Save failed: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save image: $errorMessage')));
      },
    );
  }

  void _removeImage(int index) async {
    final path = savedImagePaths[index];
    if (path != null) {
      try {
        final result = await FlutterMediaDelete.deleteMediaFile(path);
        debugPrint('Deletion result: $result');
      } catch (e) {
        debugPrint('Error deleting file: $e');
      }
    }

    // Update local UI and SharedPreferences
    setState(() {
      capturedImages[index] = null;
      savedImagePaths[index] = null;
    });

    await SharedPreferencesHelper.setCapturedImagePaths(savedImagePaths);

    if (imageCount != null && imageCount! > 0) {
      final newCount = imageCount! - 1;
      await SharedPreferencesHelper.saveImageCount(newCount);
      setState(() {
        imageCount = newCount;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (arguments != null) {
        formBloc =
            arguments['compoundParkingFormBloc'] as CompoundParkingFormBloc;
      }
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderLayout(
        bottomSize: noBottomAppBarSize,
        title: AppLocalizations.of(context)!.formPicture,
        hideActionButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: GridView.builder(
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: kOrange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: kOrange),
                        ),
                        child: capturedImages[index] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  capturedImages[index]!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              )
                            : Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  color: kOrange,
                                  size: 40,
                                ),
                              ),
                      ),
                      if (capturedImages[index] != null)
                        Positioned(
                          top: 5,
                          left: 5,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PrimaryButton(
                    buttonWidth: 0.4,
                    borderRadius: 10.0,
                    color: accentCanvasColor,
                    onPressed: () => Navigator.of(context).pop(),
                    label: Text(
                      AppLocalizations.of(context)!.ok,
                      style: textStyleNormal(color: kWhite),
                    ),
                  ),
                  PrimaryButton(
                    buttonWidth: 0.4,
                    borderRadius: 10.0,
                    color: accentCanvasColor,
                    onPressed: _captureImage,
                    label: Text(
                      AppLocalizations.of(context)!.capture,
                      style: textStyleNormal(color: kWhite),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
