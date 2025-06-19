import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:eo_apk_mbk_v2/routes/route_manager.dart';
import 'package:eo_apk_mbk_v2/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:eo_apk_mbk_v2/src/localization/app_localizations.dart';

class SidebarLayout extends StatefulWidget {
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
  const SidebarLayout({
    super.key,
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
  });

  @override
  State<SidebarLayout> createState() => _SidebarLayoutState();
}

class _SidebarLayoutState extends State<SidebarLayout> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        hoverTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: actionColor.withOpacity(0.37)),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.28), blurRadius: 30),
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(color: Colors.white, size: 20),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(color: canvasColor),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(color: kWhite),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('assets/images/logo_transparent.png'),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'Home',
          onTap: () => Navigator.pushReplacementNamed(
            context,
            RouteManager.homeScreen,
            arguments: {
              'userModel': widget.userModel,
              'unitModel': widget.unitModel,
              'handHeldId': widget.handHeldId,
              'vehicleTypeModel': widget.vehicleTypeModel,
              'vehicleMakesModel': widget.vehicleMakesModel,
              'vehicleModelsModel': widget.vehicleModelsModel,
              'vehicleColorModel': widget.vehicleColorModel,
              'offenceActModel': widget.offenceActModel,
              'offenceSectionModel': widget.offenceSectionModel,
              'offenceAreaModel': widget.offenceAreaModel,
              'offenceLocationModel': widget.offenceLocationModel,
            },
          ),
        ),
        SidebarXItem(
          icon: Icons.file_copy_rounded,
          label: AppLocalizations.of(context)!.duplicateCopy,
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(
              context,
              RouteManager.duplicateCopyParkingScreen,
              arguments: {
                'userModel': widget.userModel,
                'unitModel': widget.unitModel,
                'handHeldId': widget.handHeldId,
                'vehicleTypeModel': widget.vehicleTypeModel,
                'vehicleMakesModel': widget.vehicleMakesModel,
                'vehicleModelsModel': widget.vehicleModelsModel,
                'vehicleColorModel': widget.vehicleColorModel,
                'offenceActModel': widget.offenceActModel,
                'offenceSectionModel': widget.offenceSectionModel,
                'offenceAreaModel': widget.offenceAreaModel,
                'offenceLocationModel': widget.offenceLocationModel,
              },
            );
          },
        ),
        SidebarXItem(
          icon: Icons.settings,
          label: AppLocalizations.of(context)!.setting,
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(
              context,
              RouteManager.settingScreen,
              arguments: {'handHeldId': widget.handHeldId},
            );
          },
        ),
        SidebarXItem(
          icon: Icons.logout_outlined,
          label: AppLocalizations.of(context)!.logout,
          onTap: () {
            CustomDialog.show(
              context,
              dialogType: 2,
              icon: Icons.warning,
              isDissmissable: false,
              title: AppLocalizations.of(context)!.logout,
              description: AppLocalizations.of(context)!.logoutDesc,
              btnOkText: AppLocalizations.of(context)!.yes,
              btnOkOnPress: () async {
                await SharedPreferencesHelper.deleteLoginCredential();
                Navigator.pushReplacementNamed(
                  context,
                  RouteManager.splashScreen,
                );
              },
              btnCancelText: AppLocalizations.of(context)!.no,
              btnCancelOnPress: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ],
    );
  }
}
