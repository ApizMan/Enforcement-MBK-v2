import 'package:eo_apk_mbk_v2/helpers/date_time_formatter_helper.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';

class PrintingDocument {
  int incrementPositionY = 0;
  String printingData = '';
  String paperLength;

  PrintingDocument([this.paperLength = '2000']);

  void drawBox(int xStart, int yStart, int xEnd, int yEnd) {
    printingData += 'BOX $xStart $yStart $xEnd $yEnd 1 \r\n';
  }

  void drawImageName(int xStart, int yStart, String imageName) {
    incrementPositionY += yStart;
    printingData += '^FO$xStart,$incrementPositionY';
    printingData += '^IME:$imageName^FS \r\n';
  }

  void drawLine(int xStart, int yStart, int xEnd, int yEnd) {
    printingData += 'LINE $xStart $yStart $xEnd $yEnd 1 \r\n';
  }

  void drawBarcode128(int x, int y, int height, String data) {
    incrementPositionY += y;
    printingData += '^FO$x,$incrementPositionY^BY2';
    printingData += '^BCN,$height,N,N,N^FD$data^FS \r\n';
  }

  void drawBarcode39(int x, int y, int height, String data) {
    incrementPositionY += y;
    printingData += '^FO$x,$incrementPositionY^BY3';
    printingData += '^B3N,N,$height,Y,N^FD$data^FS \r\n';
  }

  void drawQRCode(int x, int y, int size, String data) {
    incrementPositionY += y;
    printingData += '^FO$x,$incrementPositionY';
    printingData += '^BQN,2,$size^FD$data^FS \r\n';
  }

  void drawText(int x, int y, int fontSize, String data) {
    incrementPositionY += y;
    printingData +=
        '^FO$x,$incrementPositionY^A0,I,$fontSize,$fontSize^FD$data^FS \r\n';
  }

  void drawTextFlow(
    int x,
    int y,
    int fontSize,
    int width,
    String justification,
    String data,
  ) {
    incrementPositionY += y;
    printingData += '^CF0,$fontSize,$fontSize^FO$x,$incrementPositionY';
    printingData += '^FB$width,10,1,$justification';
    printingData += '^FD$data^FS \r\n';
  }

  void drawTextInBox(int x, int y, String data) {
    incrementPositionY += y;
    for (int i = 0; i < data.length; i++) {
      printingData += 'T TNR08BO.cpf 0 $x $incrementPositionY ${data[i]} \r\n';
      x += 40;
    }
  }

  void drawStatusBox({
    required Map<String, dynamic> userData,
    required String handHeldId,
    required int compoundTotal,
    required int compoundPendingTotal,
    required int countImage,
  }) {
    const int startX = 30;
    const int startY = 30;
    const int boxWidth = 550;
    const int boxHeight = 450;
    const int lineHeight = 40;
    const int labelX = 40;
    const int valueX = 300;

    // Reset vertical tracker
    incrementPositionY = 0;

    // Outer Box
    drawBox(startX, startY, startX + boxWidth, startY + boxHeight);

    // Title Box
    drawBox(startX, startY, startX + boxWidth, startY + 40);
    drawText(startX + 200, 10, 30, "STATUS");

    incrementPositionY = 60;

    void drawRow(String label, String value) {
      drawText(labelX, 0, 26, label);
      drawText(valueX, 0, 24, value);
      incrementPositionY += lineHeight;
    }

    drawRow("Unit:", userData['unit'] ?? '-');
    drawRow("Handheld ID:", handHeldId);
    drawRow("Login ID:", userData['id'] ?? '-');
    drawRow("Name:", userData['name'] ?? '-');
    drawRow("Total Notice:", compoundTotal.toString());
    drawRow("Not Yet Uploaded:", compoundPendingTotal.toString());
    drawRow("Total Pictures:", countImage.toString());
    drawRow("Total Transactions:", "0");
    drawRow("Total Amount:", "RM 0.00");
  }

  PrintingDocument createNoticeDuplicateCopy({
    required OfficerCompoundModel model,
    required String rawMac,
    required List<UserModel> userModel,
    required List<OfficerUnitModel> unitModel,
    required String handHeldId,
    required List<VehicleTypeModel> vehicleTypeModel,
    required List<VehicleBrandModel> vehicleMakesModel,
    required List<VehicleModelsModel> vehicleModelsModel,
    required List<VehicleColorModel> vehicleColorModel,
    required List<OffenceActModel> offenceActModel,
    required List<OffenceSectionModel> offenceSectionModel,
    required List<OffenceAreaModel> offenceAreaModel,
    required List<OffenceLocationModel> offenceLocationModel,
  }) {
    PrintingDocument doc = PrintingDocument('2500');

    if (model.isClamping == true) {
      doc = PrintingDocument('2200');
    }

    // Draw stored images by name
    doc.drawImageName(-5, 0, 'small.png');

    doc.drawTextFlow(150, 60, 40, 670, 'C', 'MAJLIS BANDARAYA KUANTAN');
    doc.drawText(200, 50, 25, 'NOTIS KESALAHAN SERTA TAWARAN MENGKOMPAUN');
    doc.drawText(240, 30, 25, 'DI BAWAH PERINTAH PENGANGKUTAN JALAN');
    doc.drawText(220, 30, 25, '(PERUNTUKAN MENGENAI TEMPAT LETAK KERETA)');
    doc.drawText(270, 30, 25, 'MAJLIS PERBANDARAN KUANTAN 2005');

    doc.drawBarcode128(10, 75, 70, model.noticeNo!);
    doc.drawBarcode128(500, 0, 70, 'H76255');

    doc.drawText(10, 100, 30, 'NO. KOMPAUN');
    doc.drawText(500, 0, 30, 'KOD HASIL');
    doc.drawText(10, 40, 35, model.noticeNo!);
    doc.drawText(500, 0, 35, 'H76255');

    final raw = model.offenceDateString.toString();

    doc.drawText(10, 60, 20, 'TARIKH');
    doc.drawText(
        230, 0, 25, ': ${DateTimeFormatterHelper.formatToDisplayDate(raw)}');
    doc.drawText(10, 30, 20, 'WAKTU');
    doc.drawText(
        230, 0, 25, ': ${DateTimeFormatterHelper.formatToDisplayTime(raw)}');

    doc.drawText(10, 50, 30, 'Kepada Pemandu / Pemilik Kenderaan :');
    doc.drawText(10, 35, 20, 'NO KENDERAAN');
    doc.drawText(230, 0, 28, ': ${model.vehicleNo}');
    doc.drawText(10, 30, 20, 'JENIS KENDERAAN');
    doc.drawText(230, 0, 25, ': ${model.vehicleType}');
    doc.drawText(10, 30, 20, 'NO CUKAI');
    doc.drawText(230, 0, 25, ': ${model.roadTaxNo}');

    doc.drawText(10, 30, 20, 'MODEL KENDERAAN');
    doc.drawText(230, 0, 25, ': ${model.vehicleMakeModel}');

    doc.drawText(10, 30, 20, 'WARNA');
    doc.drawText(230, 0, 25, ': ${model.vehicleColor}');
    doc.drawText(10, 30, 20, 'ZON');
    doc.drawText(230, 0, 25, ': ${model.offenceArea}');
    doc.drawText(10, 30, 20, 'JALAN');
    doc.drawText(230, 0, 25, ': ${model.offenceLocation}');
    doc.drawText(10, 30, 20, 'LOKASI');
    doc.drawText(230, 0, 25, ': ${model.offenceLocationDetails}');
    doc.drawText(10, 30, 20, 'NO PETAK');
    doc.drawText(230, 0, 25, ': ${model.squarePoleNo}');

    doc.drawTextFlow(0, 60, 30, 800, 'J',
        'SILA AMBIL PERHATIAN BAHAWA TUAN/PUAN SEPERTIMANA TARIKH DAN WAKTU YANG DINYATAKAN TUAN/PUAN TELAH DIDAPATI MELAKUKAN KESALAHAN SEPERTI BERIKUT:');

    doc.drawText(0, 120, 20, 'PERUNTUKAN UNDANG-UNDANG :');
    // Find OffenceSectionModel from the offenceSectionCode
    final sectionModel = offenceSectionModel.firstWhere(
      (s) => s.id == model.offenceSectionCode,
      orElse: () => OffenceSectionModel(id: '', description: '', actId: ''),
    );

    // Use actId from sectionModel to find the corresponding OffenceActModel
    final actModel = offenceActModel.firstWhere(
      (a) => a.id == sectionModel.actId,
      orElse: () => OffenceActModel(
        id: '',
        description: '',
      ),
    );

    // Now use actModel.description
    doc.drawTextFlow(50, 30, 25, 700, 'J', actModel.description!);

    doc.drawText(0, 60, 20, 'SEKSYEN / KAEDAH / PERINTAH :');
    doc.drawText(
        50,
        30,
        25,
        sectionModel.subsectionNo != null
            ? 'PERINTAH ${sectionModel.sectionNo!}${sectionModel.subsectionNo!}'
            : 'PERINTAH ${sectionModel.sectionNo!}');

    doc.drawText(0, 60, 20, 'KESALAHAN :');
    doc.drawTextFlow(50, 30, 25, 700, 'J', sectionModel.description!);

    doc.drawText(0, 130, 20, 'NOTA :');
    doc.drawTextFlow(50, 30, 25, 700, 'J', model.notes!);

    doc.drawText(0, 130, 20, 'DIKELUARKAN OLEH');
    doc.drawText(230, 0, 25, ': ${model.officerId}');
    doc.drawText(0, 30, 20, 'KOD SAKSI');
    doc.drawText(230, 0, 25, ': ${model.officerSaksi}');

    doc.drawTextFlow(0, 130, 25, 400, 'C',
        '.....................................................\\&b.p. DATUK BANDAR\\&MAJLIS BANDARAYA KUANTAN');
    doc.drawText(0, 100, 25, '-----------------------------------------------');

    doc.drawText(0, 50, 23, 'NO. KOMPAUN');
    doc.drawText(230, 0, 23, ': ${model.noticeNo}');
    doc.drawText(420, 0, 23, 'SEKSYEN KESALAHAN');
    doc.drawText(
        680,
        0,
        23,
        sectionModel.subsectionNo != null
            ? ': ${sectionModel.sectionNo}${sectionModel.subsectionNo}'
            : ': ${sectionModel.sectionNo}');

    doc.drawText(0, 30, 23, 'TARIKH');
    doc.drawText(
        230, 0, 23, ': ${DateTimeFormatterHelper.formatToDisplayDate(raw)}');
    doc.drawText(420, 0, 23, 'KOD HASIL');
    doc.drawText(680, 0, 23, ': H76255');
    doc.drawText(0, 30, 23, 'NO KENDERAAN');
    doc.drawText(230, 0, 28, ': ${model.vehicleNo}');

    doc.drawTextFlow(0, 60, 30, 800, 'J',
        'TAWARAN UNTUK MENGKOMPAUN KESALAHAN INI BERKUATKUASA DARI TARIKH NOTIS INI DIKELUARKAN. JIKA SEKIRANYA KOMPAUN INI TIDAK DIJELASKAN DALAM TEMPOH TERSEBUT MAKA TINDAKAN UNDANG - UNDANG AKAN DITERUSKAN.');

    final descs = [
      sectionModel.description1,
      sectionModel.description2,
      sectionModel.description3,
      sectionModel.description4,
    ];

    final amounts = [
      sectionModel.amount1,
      sectionModel.amount2,
      sectionModel.amount3,
      sectionModel.amount4,
    ];

    // Step 1: Build valid columns
    final validPairs = <MapEntry<String, String>>[];

    for (int i = 0; i < descs.length; i++) {
      final desc = descs[i];
      final amt = amounts[i];
      if (desc != null && desc.isNotEmpty && amt != null) {
        validPairs.add(MapEntry(desc, 'RM ${amt.toStringAsFixed(2)}'));
      }
    }

    // Step 2: Format each column with fixed-width spacing
    const int columnWidth = 26;

    String padCenter(String text, int width) {
      final spaceCount = width - text.length;
      if (spaceCount <= 0) return text;
      final left = spaceCount ~/ 15;
      final right = spaceCount - left;
      return ' ' * left + text + ' ' * right;
    }

    final descLine =
        validPairs.map((e) => padCenter(e.key, columnWidth)).join();
    final amountLine =
        validPairs.map((e) => padCenter(e.value, columnWidth)).join();

    // Step 3: Determine font size
    final bool hasDesc3and4 = sectionModel.description3 != null &&
        sectionModel.description3!.isNotEmpty &&
        sectionModel.description4 != null &&
        sectionModel.description4!.isNotEmpty;

    final int descFontSize = hasDesc3and4 ? 20 : 30;
    final int amountFontSize = hasDesc3and4 ? 30 : 40;

    // Step 4: Draw both lines centered
    doc.drawTextFlow(0, 200, descFontSize, 800, 'C', descLine);
    doc.drawTextFlow(100, 30, amountFontSize, 800, 'C', amountLine);

    doc.drawTextFlow(0, 50, 28, 800, 'J',
        'Tempoh bayaran kompaun dikira dari tarikh kesalahan dilakukan termasuk hari ahad dan hari kelepasan Am');

    if (model.isClamping == true) {
      doc.drawTextFlow(0, 150, 20, 800, 'C', 'KENDERAAN TELAH DIKUNCI TAYAR');
    }

    return doc;
  }

  PrintingDocument createNotice({
    required OfficerCompoundModel model,
    required String rawMac,
    required List<UserModel> userModel,
    required List<OfficerUnitModel> unitModel,
    required String handHeldId,
    required List<VehicleTypeModel> vehicleTypeModel,
    required List<VehicleBrandModel> vehicleMakesModel,
    required List<VehicleModelsModel> vehicleModelsModel,
    required List<VehicleColorModel> vehicleColorModel,
    required List<OffenceActModel> offenceActModel,
    required List<OffenceSectionModel> offenceSectionModel,
    required List<OffenceAreaModel> offenceAreaModel,
    required List<OffenceLocationModel> offenceLocationModel,
  }) {
    PrintingDocument doc = PrintingDocument('2500');

    if (model.isClamping == true) {
      doc = PrintingDocument('2200');
    }

    // Draw stored images by name
    doc.drawImageName(-5, 0, 'small.png');

    doc.drawTextFlow(150, 60, 40, 670, 'C', 'MAJLIS BANDARAYA KUANTAN');
    doc.drawText(200, 50, 25, 'NOTIS KESALAHAN SERTA TAWARAN MENGKOMPAUN');
    doc.drawText(240, 30, 25, 'DI BAWAH PERINTAH PENGANGKUTAN JALAN');
    doc.drawText(220, 30, 25, '(PERUNTUKAN MENGENAI TEMPAT LETAK KERETA)');
    doc.drawText(270, 30, 25, 'MAJLIS PERBANDARAN KUANTAN 2005');

    doc.drawBarcode128(10, 75, 70, model.noticeNo!);
    doc.drawBarcode128(500, 0, 70, 'H76255');

    doc.drawText(10, 100, 30, 'NO. KOMPAUN');
    doc.drawText(500, 0, 30, 'KOD HASIL');
    doc.drawText(10, 40, 35, model.noticeNo!);
    doc.drawText(500, 0, 35, 'H76255');

    final raw = model.offenceDateString.toString();

    doc.drawText(10, 60, 20, 'TARIKH');
    doc.drawText(
        230, 0, 25, ': ${DateTimeFormatterHelper.formatToDisplayDate(raw)}');
    doc.drawText(10, 30, 20, 'WAKTU');
    doc.drawText(
        230, 0, 25, ': ${DateTimeFormatterHelper.formatToDisplayTime(raw)}');

    doc.drawText(10, 50, 30, 'Kepada Pemandu / Pemilik Kenderaan :');
    doc.drawText(10, 35, 20, 'NO KENDERAAN');
    doc.drawText(230, 0, 28, ': ${model.vehicleNo}');
    doc.drawText(10, 30, 20, 'JENIS KENDERAAN');
    doc.drawText(230, 0, 25, ': ${model.vehicleType}');
    doc.drawText(10, 30, 20, 'NO CUKAI');
    doc.drawText(230, 0, 25, ': ${model.roadTaxNo}');

    doc.drawText(10, 30, 20, 'MODEL KENDERAAN');
    doc.drawText(230, 0, 25, ': ${model.vehicleMakeModel}');

    doc.drawText(10, 30, 20, 'WARNA');
    doc.drawText(230, 0, 25, ': ${model.vehicleColor}');
    doc.drawText(10, 30, 20, 'ZON');
    doc.drawText(230, 0, 25, ': ${model.offenceArea}');
    doc.drawText(10, 30, 20, 'JALAN');
    doc.drawText(230, 0, 25, ': ${model.offenceLocation}');
    doc.drawText(10, 30, 20, 'LOKASI');
    doc.drawText(230, 0, 25, ': ${model.offenceLocationDetails}');
    doc.drawText(10, 30, 20, 'NO PETAK');
    doc.drawText(230, 0, 25, ': ${model.squarePoleNo}');

    doc.drawTextFlow(0, 60, 30, 800, 'J',
        'SILA AMBIL PERHATIAN BAHAWA TUAN/PUAN SEPERTIMANA TARIKH DAN WAKTU YANG DINYATAKAN TUAN/PUAN TELAH DIDAPATI MELAKUKAN KESALAHAN SEPERTI BERIKUT:');

    doc.drawText(0, 120, 20, 'PERUNTUKAN UNDANG-UNDANG :');
    // Find OffenceSectionModel from the offenceSectionCode
    final sectionModel = offenceSectionModel.firstWhere(
      (s) => s.id == model.offenceSectionCode,
      orElse: () => OffenceSectionModel(id: '', description: '', actId: ''),
    );

    // Use actId from sectionModel to find the corresponding OffenceActModel
    final actModel = offenceActModel.firstWhere(
      (a) => a.id == sectionModel.actId,
      orElse: () => OffenceActModel(
        id: '',
        description: '',
      ),
    );

    // Now use actModel.description
    doc.drawTextFlow(50, 30, 25, 700, 'J', actModel.description!);

    doc.drawText(0, 60, 20, 'SEKSYEN / KAEDAH / PERINTAH :');
    doc.drawText(
        50,
        30,
        25,
        sectionModel.subsectionNo != null
            ? 'PERINTAH ${sectionModel.sectionNo!}${sectionModel.subsectionNo!}'
            : 'PERINTAH ${sectionModel.sectionNo!}');

    doc.drawText(0, 60, 20, 'KESALAHAN :');
    doc.drawTextFlow(50, 30, 25, 700, 'J', sectionModel.description!);

    doc.drawText(0, 130, 20, 'NOTA :');
    doc.drawTextFlow(50, 30, 25, 700, 'J', model.notes!);

    doc.drawText(0, 130, 20, 'DIKELUARKAN OLEH');
    doc.drawText(230, 0, 25, ': ${model.officerId}');
    doc.drawText(0, 30, 20, 'KOD SAKSI');
    doc.drawText(230, 0, 25, ': ${model.officerSaksi}');

    doc.drawTextFlow(0, 130, 25, 400, 'C',
        '.....................................................\\&b.p. DATUK BANDAR\\&MAJLIS BANDARAYA KUANTAN');
    doc.drawText(0, 100, 25, '-----------------------------------------------');

    doc.drawText(0, 50, 23, 'NO. KOMPAUN');
    doc.drawText(230, 0, 23, ': ${model.noticeNo}');
    doc.drawText(420, 0, 23, 'SEKSYEN KESALAHAN');
    doc.drawText(
        680,
        0,
        23,
        sectionModel.subsectionNo != null
            ? ': ${sectionModel.sectionNo}${sectionModel.subsectionNo}'
            : ': ${sectionModel.sectionNo}');

    doc.drawText(0, 30, 23, 'TARIKH');
    doc.drawText(
        230, 0, 23, ': ${DateTimeFormatterHelper.formatToDisplayDate(raw)}');
    doc.drawText(420, 0, 23, 'KOD HASIL');
    doc.drawText(680, 0, 23, ': H76255');
    doc.drawText(0, 30, 23, 'NO KENDERAAN');
    doc.drawText(230, 0, 28, ': ${model.vehicleNo}');

    doc.drawTextFlow(0, 60, 30, 800, 'J',
        'TAWARAN UNTUK MENGKOMPAUN KESALAHAN INI BERKUATKUASA DARI TARIKH NOTIS INI DIKELUARKAN. JIKA SEKIRANYA KOMPAUN INI TIDAK DIJELASKAN DALAM TEMPOH TERSEBUT MAKA TINDAKAN UNDANG - UNDANG AKAN DITERUSKAN.');

    final descs = [
      sectionModel.description1,
      sectionModel.description2,
      sectionModel.description3,
      sectionModel.description4,
    ];

    final amounts = [
      sectionModel.amount1,
      sectionModel.amount2,
      sectionModel.amount3,
      sectionModel.amount4,
    ];

    // Step 1: Build valid columns
    final validPairs = <MapEntry<String, String>>[];

    for (int i = 0; i < descs.length; i++) {
      final desc = descs[i];
      final amt = amounts[i];
      if (desc != null && desc.isNotEmpty && amt != null) {
        validPairs.add(MapEntry(desc, 'RM ${amt.toStringAsFixed(2)}'));
      }
    }

    // Step 2: Format each column with fixed-width spacing
    const int columnWidth = 26;

    String padCenter(String text, int width) {
      final spaceCount = width - text.length;
      if (spaceCount <= 0) return text;
      final left = spaceCount ~/ 15;
      final right = spaceCount - left;
      return ' ' * left + text + ' ' * right;
    }

    final descLine =
        validPairs.map((e) => padCenter(e.key, columnWidth)).join();
    final amountLine =
        validPairs.map((e) => padCenter(e.value, columnWidth)).join();

    // Step 3: Determine font size
    final bool hasDesc3and4 = sectionModel.description3 != null &&
        sectionModel.description3!.isNotEmpty &&
        sectionModel.description4 != null &&
        sectionModel.description4!.isNotEmpty;

    final int descFontSize = hasDesc3and4 ? 20 : 30;
    final int amountFontSize = hasDesc3and4 ? 30 : 40;

    // Step 4: Draw both lines centered
    doc.drawTextFlow(0, 200, descFontSize, 800, 'C', descLine);
    doc.drawTextFlow(100, 30, amountFontSize, 800, 'C', amountLine);

    doc.drawTextFlow(0, 50, 28, 800, 'J',
        'Tempoh bayaran kompaun dikira dari tarikh kesalahan dilakukan termasuk hari ahad dan hari kelepasan Am');

    if (model.isClamping == true) {
      doc.drawTextFlow(0, 150, 20, 800, 'C', 'KENDERAAN TELAH DIKUNCI TAYAR');
    }

    return doc;
  }

  String getLabelLengthCommand() => '^LL$paperLength\r\n';
  String getPrintingData() => printingData;
}
