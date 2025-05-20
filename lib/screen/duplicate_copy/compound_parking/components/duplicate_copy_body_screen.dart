// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/theme.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:eo_apk_mbk_v2/widgets/custom_dialog.dart';
import 'package:eo_apk_mbk_v2/widgets/loading_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';

class DuplicateCopyBodyScreen extends StatefulWidget {
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
  final List<OfficerCompoundModel> compoundList;
  final String searchText; // Add in constructor
  const DuplicateCopyBodyScreen({
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
    required this.compoundList,
    required this.searchText,
  });

  @override
  State<DuplicateCopyBodyScreen> createState() =>
      _DuplicateCopyBodyScreenState();
}

class _DuplicateCopyBodyScreenState extends State<DuplicateCopyBodyScreen> {
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
                        "Duplicate Copy",
                        style: textStyleNormal(fontStyle: FontStyle.italic),
                      ),
                    ),
                    const Expanded(child: Divider()),
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
                            final model = index < widget.compoundList.length
                                ? widget.compoundList[index]
                                : OfficerCompoundModel(); // or skip with SizedBox if invalid

                            String getValue(String label) {
                              return compoundEntry.firstWhere(
                                    (e) => e['label'] == label,
                                    orElse: () => {'value': ''},
                                  )['value'] ??
                                  '';
                            }

                            final noticeNo =
                                getValue('Notice No').toLowerCase();
                            if (widget.searchText.isNotEmpty &&
                                !noticeNo.contains(widget.searchText)) {
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
                                  center: _cardDuplicateCopy(
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
                                  btnOkText:
                                      AppLocalizations.of(context)!.print,
                                  btnOkOnPress: () {},
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
