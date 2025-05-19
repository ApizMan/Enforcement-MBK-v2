import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:eo_apk_mbk_v2/resources/resources.dart';
import 'package:eo_apk_mbk_v2/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DuplicateCopyParkingScreen extends StatefulWidget {
  const DuplicateCopyParkingScreen({super.key});

  @override
  State<DuplicateCopyParkingScreen> createState() =>
      _DuplicateCopyParkingScreenState();
}

class _DuplicateCopyParkingScreenState
    extends State<DuplicateCopyParkingScreen> {
  final CompoundResourcesSharedPreferences _compoundHelper =
      CompoundResourcesSharedPreferences();
  bool _isLoading = true;

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

  @override
  void initState() {
    super.initState();
    _loadCompoundData();
  }

  Future<void> _loadCompoundData() async {
    await _compoundHelper.getCompoundParkingData();
    setState(() {
      _isLoading = false;
    });
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
    final dataSets = _compoundHelper.getDataSets();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: HeaderLayout(
        hideActionButton: true,
        bottomSize: noBottomAppBarSize,
        title: AppLocalizations.of(context)!.duplicateCopy,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: PendingDuplicateScreen(
        dataSets: dataSets,
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
        isLoading: _isLoading,
        compoundHelper: _compoundHelper,
      ),
    );
  }
}
