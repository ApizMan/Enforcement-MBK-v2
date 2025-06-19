// ignore_for_file: use_build_context_synchronously

import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';
import 'package:eo_apk_mbk_v2/helpers/theme.dart';
import 'package:eo_apk_mbk_v2/routes/route_manager.dart';
import 'package:eo_apk_mbk_v2/screen/screen.dart';
import 'package:eo_apk_mbk_v2/src/localization/app_localizations.dart';
import 'package:eo_apk_mbk_v2/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrinterFunction extends StatefulWidget {
  final Map<String, dynamic> printerMAC;
  final Map<String, dynamic> userData;
  final int compoundTotal;
  final int compoundPendingTotal;
  final int countImage;
  final String handHeldId;
  const PrinterFunction({
    super.key,
    required this.printerMAC,
    required this.handHeldId,
    required this.userData,
    required this.compoundTotal,
    required this.compoundPendingTotal,
    required this.countImage,
  });

  @override
  State<PrinterFunction> createState() => _PrinterFunctionState();
}

class _PrinterFunctionState extends State<PrinterFunction> {
  bool isPrinting = false;
  bool isChecked = false;

  /// 🔧 Normalize MAC: Accepts both `0017E9D8329F` and `00:17:E9:D8:32:9F`
  String formatMacAddress(String rawMac) {
    String clean = rawMac.replaceAll(":", "").toUpperCase();
    if (clean.length != 12) return rawMac; // fallback if invalid
    return clean
        .replaceAllMapped(RegExp(r".{2}"), (match) => "${match.group(0)}:")
        .substring(0, 17);
  }

  Future<void> connectAndPrint(
      {required String rawMac,
      required String handHeldId,
      required Map<String, dynamic> userData,
      required int compoundTotal,
      required int compoundPendingTotal,
      required int countImage}) async {
    setState(() => isPrinting = true);

    String mac = formatMacAddress(rawMac);

    try {
      final connection = await PrinterLayout.getConnection(mac: mac);

      // Generate ZPL content
      final zpl = PrinterLayout.settingPrinterLayout(
        handHeldId: handHeldId,
        userData: userData,
        compoundTotal: compoundTotal,
        compoundPendingTotal: compoundPendingTotal,
        countImage: countImage,
      );

      // Full ZPL with label height and orientation

      await PrinterLayout.printingProcess(connection: connection, zpl: zpl);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.successPrintingDesc),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to print: $e")));
    } finally {
      setState(() => isPrinting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController macController = TextEditingController(
      text: widget.printerMAC['printerMAC'] ?? '',
    );

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
          decoration: BoxDecoration(
            color: kGrey.withOpacity(0.5),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    Text(AppLocalizations.of(context)!.newPrinter),
                  ],
                ),
                spaceVertical(height: 20.0),
                // Inside your TextField widget
                TextField(
                  controller: macController,
                  enabled: isChecked,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z0-9]'),
                    ), // Allow only alphabets and numbers
                    UpperCaseTextFormatter(), // Convert to uppercase
                  ],
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.macAddress,
                    hintText: "e.g. 00:17:E9:D8:32:9F or 0017E9D8329F",
                    border: OutlineInputBorder(),
                  ),
                ),

                spaceVertical(height: 10.0),
                PrimaryButton(
                  buttonWidth: 0.9,
                  borderRadius: 10.0,
                  icon: Icon(Icons.save, color: kWhite),
                  color: kBgSuccess,
                  onPressed: isChecked
                      ? () {
                          setState(() {
                            SharedPreferencesHelper.savePrinterMAC(
                              macController.text.toString(),
                              true,
                            );

                            Navigator.pop(context);

                            Navigator.pushNamed(
                              context,
                              RouteManager.settingScreen,
                              arguments: {'handHeldId': widget.handHeldId},
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${AppLocalizations.of(context)!.macAddress} ${AppLocalizations.of(context)!.saveDesc}',
                                ),
                              ),
                            );
                          });
                        }
                      : null,
                  label: Text(
                    AppLocalizations.of(context)!.save,
                    style: textStyleNormal(color: kWhite),
                  ),
                ),
              ],
            ),
          ),
        ),
        PrimaryButton(
          buttonWidth: 0.9,
          borderRadius: 10.0,
          icon: Icon(Icons.print, color: kWhite),
          onPressed: () {
            setState(() {
              SharedPreferencesHelper.savePrinterMAC(
                macController.text.toString(),
                true,
              );

              Navigator.pop(context);

              Navigator.pushNamed(
                context,
                RouteManager.settingScreen,
                arguments: {'handHeldId': widget.handHeldId},
              );

              connectAndPrint(
                rawMac: macController.text.trim(),
                handHeldId: widget.handHeldId,
                userData: widget.userData,
                compoundTotal: widget.compoundTotal,
                compoundPendingTotal: widget.compoundPendingTotal,
                countImage: widget.countImage,
              );
            });
          },
          label: Text(
            AppLocalizations.of(context)!.connectAndPrint,
            style: textStyleNormal(color: kWhite),
          ),
        ),
      ],
    );
  }
}
