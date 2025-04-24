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

  void drawStatusBox(Map<String, dynamic> userData, String handHeldId) {
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
    drawRow("Total Notice:", "0");
    drawRow("Not Yet Uploaded:", "0");
    drawRow("Total Pictures:", "0");
    drawRow("Total Transactions:", "0");
    drawRow("Total Amount:", "RM 0.00");
  }

  String getLabelLengthCommand() => '^LL$paperLength\r\n';
  String getPrintingData() => printingData;
}
