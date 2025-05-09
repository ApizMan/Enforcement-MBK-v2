// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/gallery_manager.dart';
import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';
import 'package:eo_apk_mbk_v2/helpers/theme.dart';
import 'package:eo_apk_mbk_v2/screen/screen.dart';
import 'package:eo_apk_mbk_v2/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<File?> capturedImages = List.generate(4, (index) => null);
  List<String?> savedImagePaths = List.generate(4, (index) => null);

  @override
  void initState() {
    super.initState();
    _loadSavedImages();
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

  Future<void> _captureImage() async {
    if (!capturedImages.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Maximum of 4 images allowed.")),
      );
      return;
    }

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

    File imageFile = File(pickedFile.path);

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm photo?'),
        content: Image.file(imageFile),
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

    if (confirm == true) {
      int indexToUpdate = capturedImages.indexWhere((img) => img == null);
      if (indexToUpdate == -1) return;

      final handheldCode = await SharedPreferencesHelper.getHandheldId();
      final year = DateTime.now().year.toString();
      final serial = await SharedPreferencesHelper.getNoticeSerialNumber();
      final paddedSerial = serial.toString().padLeft(5, '0');
      final imageIndex = indexToUpdate;
      final fileName = '$handheldCode$year${paddedSerial}Pic$imageIndex.jpg';

      final directory = await getApplicationDocumentsDirectory();
      final customPath = '${directory.path}/$fileName';
      final savedFile = await File(pickedFile.path).copy(customPath);

      final bytes = await savedFile.readAsBytes();
      await ImageGallerySaverPlus.saveImage(
        Uint8List.fromList(bytes),
        name: fileName,
      );

      setState(() {
        capturedImages[indexToUpdate] = savedFile;
        savedImagePaths[indexToUpdate] = customPath;
      });

      await SharedPreferencesHelper.setCapturedImagePaths(savedImagePaths);
      await SharedPreferencesHelper.incrementNoticeSerialNumber();
    } else {
      _captureImage(); // Retry
    }
  }

  void _removeImage(int index) async {
    final path = savedImagePaths[index];
    if (path != null) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        debugPrint('Deleted local file at $path');
      }

      final fileName = path.split('/').last;
      bool deleted = await GalleryManager.deleteImageFromGallery(fileName);
      debugPrint(deleted
          ? 'Deleted $fileName from gallery'
          : 'Failed to delete $fileName from gallery');
    }

    setState(() {
      capturedImages[index] = null;
      savedImagePaths[index] = null;
    });

    await SharedPreferencesHelper.setCapturedImagePaths(savedImagePaths);
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
                    onPressed: () {},
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
