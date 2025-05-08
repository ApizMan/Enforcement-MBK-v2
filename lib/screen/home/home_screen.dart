import 'package:eo_apk_mbk_v2/controllers/home_controller.dart';
import 'package:eo_apk_mbk_v2/form_blocs/form_bloc.dart';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:eo_apk_mbk_v2/routes/route_manager.dart';
import 'package:eo_apk_mbk_v2/screen/screen.dart';
import 'package:eo_apk_mbk_v2/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());

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
              create:
                  (context) => CompoundParkingFormBloc(
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

              return FormBlocListener<
                VehicleValidationFormBloc,
                String,
                String
              >(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSubmissionFailed:
                    (context, state) => LoadingDialog.hide(context),
                onSuccess: (context, state) {
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
                child: FormBlocListener<
                  CompoundParkingFormBloc,
                  String,
                  String
                >(
                  onSubmitting: (context, state) {
                    LoadingDialog.show(context);
                  },
                  onSubmissionFailed:
                      (context, state) => LoadingDialog.hide(context),
                  onSuccess: (context, state) {
                    LoadingDialog.hide(context);
                    Navigator.popAndPushNamed(context, RouteManager.homeScreen);
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
                  child: FormBlocListener<CompoundAmFormBloc, String, String>(
                    onSubmitting: (context, state) {
                      LoadingDialog.show(context);
                    },
                    onSubmissionFailed:
                        (context, state) => LoadingDialog.hide(context),
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
                        bottomSize:
                            isCompoundParking
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
                      ),
                      body:
                          isCompoundParking
                              ? CompoundParkingScreen(
                                compoundParkingFormBloc:
                                    compoundParkingFormBloc,
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
}
