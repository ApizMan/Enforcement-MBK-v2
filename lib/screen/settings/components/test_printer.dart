import 'dart:convert';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/print_document.dart';
import 'package:eo_apk_mbk_v2/helpers/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class PrinterFunction extends StatefulWidget {
  const PrinterFunction({super.key});

  @override
  State<PrinterFunction> createState() => _PrinterFunctionState();
}

class _PrinterFunctionState extends State<PrinterFunction> {
  final TextEditingController macController = TextEditingController(
    text: "0017E9D8329F", // Example without colons
  );
  bool isPrinting = false;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.locationWhenInUse,
    ].request();
  }

  /// 🔧 Normalize MAC: Accepts both `0017E9D8329F` and `00:17:E9:D8:32:9F`
  String formatMacAddress(String rawMac) {
    String clean = rawMac.replaceAll(":", "").toUpperCase();
    if (clean.length != 12) return rawMac; // fallback if invalid
    return clean
        .replaceAllMapped(RegExp(r".{2}"), (match) => "${match.group(0)}:")
        .substring(0, 17);
  }

  Future<void> connectAndPrint(String rawMac) async {
    setState(() => isPrinting = true);

    String mac = formatMacAddress(rawMac);

    try {
      print("🔌 Connecting to $mac...");
      BluetoothConnection connection = await BluetoothConnection.toAddress(mac);
      print("✅ Connected to $mac");

      // Generate ZPL content
      PrintingDocument doc = PrintingDocument("500");
      doc.drawText(50, 30, 40, "Hello from Flutter!");
      doc.drawQRCode(50, 50, 5, "https://example.com");
      doc.drawBarcode128(50, 50, 100, "1234567890");

      // Full ZPL with label height and orientation
      String zpl = '''
! U1 setvar "device.languages" "zpl"
^XA
^POI
^FWN
${doc.getLabelLengthCommand()}${doc.getPrintingData()}^XZ
''';

      connection.output.add(Utf8Encoder().convert(zpl));
      await connection.output.allSent;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Print sent to Zebra printer!")),
      );

      await Future.delayed(const Duration(seconds: 2));
      await connection.close();
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to print: $e")));
    } finally {
      setState(() => isPrinting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    Text("Pencetak Baru"),
                  ],
                ),
                spaceVertical(height: 20.0),
                TextField(
                  controller: macController,
                  enabled: isChecked, // Enable/disable based on checkbox
                  decoration: const InputDecoration(
                    labelText: "MAC Address",
                    hintText: "e.g. 00:17:E9:D8:32:9F or 0017E9D8329F",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.print),
          label: Text(isPrinting ? "Printing..." : "Connect & Print"),
          onPressed:
              isPrinting
                  ? null
                  : () => connectAndPrint(macController.text.trim()),
        ),
      ],
    );
  }
}
