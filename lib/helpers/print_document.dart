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

  String getLabelLengthCommand() => '^LL$paperLength\r\n';
  String getPrintingData() => printingData;
}
