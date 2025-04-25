import 'package:eo_apk_mbk_v2/controllers/home_controller.dart';
import 'package:eo_apk_mbk_v2/form_blocs/form_bloc.dart';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/theme.dart';
import 'package:eo_apk_mbk_v2/routes/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class HeaderLayout extends StatelessWidget implements PreferredSizeWidget {
  final CompoundParkingFormBloc? compoundParkingFormBloc;
  final CompoundAmFormBloc? compoundAmFormBloc;
  final String title;
  final bool showTabBar;
  final double bottomSize;
  const HeaderLayout({
    super.key,
    required this.title,
    required this.bottomSize,
    this.showTabBar = false,
    this.compoundAmFormBloc,
    this.compoundParkingFormBloc,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return AppBar(
      excludeHeaderSemantics: true,
      backgroundColor: accentCanvasColor,
      foregroundColor: kWhite,
      title: Text(
        title,
        style: textStyleNormal(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: kWhite,
        ),
      ),
      centerTitle: true,
      actions: [
        PopupMenuButton(
          onSelected: (value) {},
          itemBuilder:
              (context) => [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.edit_document, color: kBlack),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          AppLocalizations.of(context)!.compoundParking,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Future.delayed(Duration.zero, () {
                      controller.setScreen(RouteManager.compoundParkingBody);
                    });
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.castle_rounded, color: kBlack),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(AppLocalizations.of(context)!.compoundAm),
                      ),
                    ],
                  ),
                  onTap: () {
                    Future.delayed(Duration.zero, () {
                      controller.setScreen(RouteManager.compoundAmBody);
                    });
                  },
                ),
              ],
        ),
      ],
      bottom:
          showTabBar
              ? PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Container(
                  color: kBackgroundColor,
                  child: TabBar(
                    dividerColor: kBackgroundColor,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(
                        icon: Icon(
                          Icons.directions_car,
                          color: accentCanvasColor,
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.warning_rounded,
                          color: accentCanvasColor,
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.insert_drive_file_rounded,
                          color: accentCanvasColor,
                        ),
                      ),
                    ],
                    onTap: (value) {},
                  ),
                ),
              )
              : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + bottomSize);
}
