// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:eo_apk_mbk_v2/form_blocs/form_bloc.dart';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';
import 'package:eo_apk_mbk_v2/helpers/theme.dart';
import 'package:eo_apk_mbk_v2/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

class SummaryFaultScreen extends StatefulWidget {
  final VehicleValidationFormBloc? vehicleValidationFormBloc;
  final CompoundParkingFormBloc? compoundParkingFormBloc;

  const SummaryFaultScreen({
    super.key,
    this.vehicleValidationFormBloc,
    this.compoundParkingFormBloc,
  });

  @override
  State<SummaryFaultScreen> createState() => _SummaryFaultScreenState();
}

class _SummaryFaultScreenState extends State<SummaryFaultScreen> {
  String _currentTime = '-';

  DateTime? _ntpTime;
  late Timer _timer;
  late Timer _scrollTimer;
  final ScrollController _scrollController = ScrollController();
  bool _userInteracted = false;

  @override
  void initState() {
    super.initState();
    _initNtpTime(); // ⬅️ Start with NTP time fetch
    _startAutoScroll();
    _getBtnPushStatus();
  }

  void _startAutoScroll() {
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!_userInteracted && _scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.offset;

        if (currentScroll < maxScroll) {
          _scrollController.jumpTo(currentScroll + 1);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollTimer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initNtpTime() async {
    try {
      _ntpTime = await NTP.now();
      _updateCurrentTime();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _updateCurrentTime();
      });
    } catch (e) {
      print("❌ Failed to get NTP time: $e");
      _ntpTime = DateTime.now(); // fallback
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _updateCurrentTime();
      });
    }
  }

  void _updateCurrentTime() {
    if (_ntpTime == null) return;

    final now = _ntpTime!
        .add(Duration(seconds: DateTime.now().difference(_ntpTime!).inSeconds));
    setState(() {
      _currentTime = _formatDateTime(now);
    });

    final formattedForStorage =
        DateFormat('yyyyMMddhhmma').format(now).toUpperCase();
    widget.compoundParkingFormBloc?.dateTime.updateValue(formattedForStorage);
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm:ss a').format(dateTime);
  }

  Future<bool> _getBtnPushStatus() async {
    final response = await SharedPreferencesHelper.getCheckPush();

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded(child: _vehicleDetails(context)),
          spaceVertical(height: 20.0),
          Expanded(child: _faultDetails(context)),
          spaceVertical(height: 20.0),
          PrimaryButton(
            buttonWidth: 1,
            borderRadius: 10.0,
            color: accentCanvasColor,
            onPressed: () {
              setState(() {
                // Submit the form
                widget.compoundParkingFormBloc?.submit();
              });
            },
            label: Text(
              AppLocalizations.of(context)!.print,
              style: textStyleNormal(color: kWhite),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vehicleDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(AppLocalizations.of(context)!.vehicleDetails),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: _sectionBoxDecoration(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _twoColumnRow(
                    AppLocalizations.of(context)!.vehicleNumber,
                    AppLocalizations.of(context)!.taxRoadNumber,
                    widget.vehicleValidationFormBloc?.plateNumber.value ?? '',
                    widget.compoundParkingFormBloc?.taxNumber.value ?? '',
                  ),
                  spaceVertical(height: 10.0),
                  _twoColumnRow(
                    AppLocalizations.of(context)!.brands,
                    AppLocalizations.of(context)!.model,
                    widget.compoundParkingFormBloc?.showOtherBrand.value == true
                        ? '${widget.compoundParkingFormBloc?.brand.value?.description} - ${widget.compoundParkingFormBloc?.otherBrand.value}'
                        : widget.compoundParkingFormBloc?.brand.value
                                ?.description ??
                            '',
                    widget.compoundParkingFormBloc?.showOtherModel.value == true
                        ? '${widget.compoundParkingFormBloc?.model.value?.description} - ${widget.compoundParkingFormBloc?.otherModel.value}'
                        : widget.compoundParkingFormBloc?.model.value
                                ?.description ??
                            '',
                  ),
                  spaceVertical(height: 10.0),
                  _twoColumnRow(
                    AppLocalizations.of(context)!.bodyType,
                    AppLocalizations.of(context)!.color,
                    widget.compoundParkingFormBloc?.type.value?.description ??
                        '',
                    widget.compoundParkingFormBloc?.showOtherColor.value == true
                        ? '${widget.compoundParkingFormBloc?.color.value?.description} - ${widget.compoundParkingFormBloc?.otherColor.value}'
                        : widget.compoundParkingFormBloc?.color.value
                                ?.description ??
                            '',
                  ),
                  spaceVertical(height: 10.0),
                  Text(
                    AppLocalizations.of(context)!.images,
                    style: textStyleNormal(
                      color: accentCanvasColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  spaceVertical(height: 10.0),
                  _imageRowPreview(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _faultDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(AppLocalizations.of(context)!.faultDetail),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: _sectionBoxDecoration(),
            child: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                if (notification.direction != ScrollDirection.idle) {
                  setState(() {
                    _userInteracted = true;
                  });
                }
                return false;
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _labelAndValue(
                      AppLocalizations.of(context)!.dateAndTime,
                      _currentTime,
                    ),
                    _labelAndValue(
                      AppLocalizations.of(context)!.legalProvisions,
                      widget.compoundParkingFormBloc?.actLaw.value
                              ?.description ??
                          '',
                    ),
                    _labelAndValue(
                      AppLocalizations.of(context)!.sectionOrOrderOrMethod,
                      widget.compoundParkingFormBloc?.section.value
                              ?.description ??
                          '',
                    ),
                    _labelAndValue(
                      AppLocalizations.of(context)!.zone,
                      widget.compoundParkingFormBloc?.area.value?.description ??
                          '',
                    ),
                    _labelAndValue(
                      AppLocalizations.of(context)!.placement,
                      widget.compoundParkingFormBloc?.showOtherPlacement
                                  .value ==
                              true
                          ? '${widget.compoundParkingFormBloc?.placement.value?.description} - ${widget.compoundParkingFormBloc?.otherPlacement.value}'
                          : widget.compoundParkingFormBloc?.placement.value
                                  ?.description ??
                              '',
                    ),
                    _labelAndValue(
                      AppLocalizations.of(context)!.locationDetail,
                      widget.compoundParkingFormBloc?.locationDetail.value ??
                          '',
                    ),
                    _labelAndValue(
                      AppLocalizations.of(context)!.vehicleClamping,
                      widget.compoundParkingFormBloc?.vehicleClamping.value ??
                          '',
                    ),
                    _labelAndValue(
                      AppLocalizations.of(context)!.notes,
                      widget.compoundParkingFormBloc?.notes.value ?? '',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Container(
      height: 30,
      width: double.infinity,
      decoration: BoxDecoration(
        color: accentCanvasColor.withOpacity(0.5),
        border: Border.all(color: accentCanvasColor),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(title, style: textStyleNormal(fontWeight: FontWeight.bold)),
      ),
    );
  }

  BoxDecoration _sectionBoxDecoration() {
    return BoxDecoration(
      color: kWhite,
      border: Border.all(color: accentCanvasColor),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(10.0),
        bottomRight: Radius.circular(10.0),
      ),
    );
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
                  fontWeight: FontWeight.bold,
                  color: kBlack,
                ),
              ),
            ),
            Expanded(
              child: Text(
                label2,
                style: textStyleNormal(
                  fontWeight: FontWeight.bold,
                  color: kBlack,
                ),
              ),
            ),
          ],
        ),
        spaceVertical(height: 10.0),
        Row(
          children: [
            Expanded(
              child: Text(
                value1,
                style: textStyleNormal(color: accentCanvasColor),
              ),
            ),
            Expanded(
              child: Text(
                value2,
                style: textStyleNormal(color: accentCanvasColor),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _labelAndValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textStyleNormal(
            color: kBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        spaceVertical(height: 10.0),
        Text(value, style: textStyleNormal(color: accentCanvasColor)),
        spaceVertical(height: 10.0),
      ],
    );
  }

  Widget _imageRowPreview() {
    return FutureBuilder<List<String?>>(
      future: SharedPreferencesHelper.getCapturedImagePaths(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }

        final paths = snapshot.data!;
        final images = paths.where((path) => path != null).map((path) {
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(path!),
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: images),
        );
      },
    );
  }
}
