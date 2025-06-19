// ignore_for_file: deprecated_member_use

import 'package:eo_apk_mbk_v2/controllers/home_controller.dart';
import 'package:eo_apk_mbk_v2/form_blocs/form_bloc.dart';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/theme.dart';
import 'package:eo_apk_mbk_v2/routes/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:eo_apk_mbk_v2/src/localization/app_localizations.dart';
import 'package:get/get.dart';

class HeaderLayout extends StatelessWidget implements PreferredSizeWidget {
  final CompoundParkingFormBloc? compoundParkingFormBloc;
  final CompoundAmFormBloc? compoundAmFormBloc;
  final String title;
  final bool showTabBar;
  final bool hideActionButton;
  final double bottomSize;
  final Widget? leading;
  final List<Tab>? tabItems;
  const HeaderLayout({
    super.key,
    required this.title,
    required this.bottomSize,
    this.showTabBar = false,
    this.hideActionButton = false,
    this.compoundAmFormBloc,
    this.compoundParkingFormBloc,
    this.leading,
    this.tabItems,
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
      leading: leading,
      actions: hideActionButton
          ? null
          : [
              PopupMenuButton(
                onSelected: (value) {},
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.edit_document, color: kBlack),
                        const SizedBox(width: 10),
                        Text(AppLocalizations.of(context)!.compoundParking),
                      ],
                    ),
                    onTap: () {
                      Future.delayed(Duration.zero, () {
                        controller.setScreen(RouteManager.compoundParkingBody);
                      });
                    },
                  ),
                  PopupMenuItem(
                    enabled: false,
                    child: Row(
                      children: [
                        Icon(Icons.castle_rounded, color: kBlack),
                        const SizedBox(width: 10),
                        Text(AppLocalizations.of(context)!.compoundAm),
                        const SizedBox(width: 20),
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: kGrey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.comingSoon,
                            style: textStyleNormal(
                              fontSize: 10.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
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
      bottom: showTabBar
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Container(
                color: kBackgroundColor,
                child: TabBar(
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: tabItems ?? const [],
                ),
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + bottomSize);
}
