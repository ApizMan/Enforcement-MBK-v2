class OffenceSectionModel {
  String? actId;
  int? amount1;
  int? amount2;
  int? amount3;
  int? amount4;
  String? description;
  String? description1;
  String? description2;
  String? description3;
  String? description4;
  String? id;
  int? maxAmount;
  String? resultCode;
  String? sectionNo;
  int? smallAmount1;
  int? smallAmount2;
  int? smallAmount3;
  int? smallAmount4;
  String? subsectionNo;
  int? zone1;
  int? zone2;
  int? zone3;
  int? zone4;

  OffenceSectionModel({
    this.actId,
    this.amount1,
    this.amount2,
    this.amount3,
    this.amount4,
    this.description,
    this.description1,
    this.description2,
    this.description3,
    this.description4,
    this.id,
    this.maxAmount,
    this.resultCode,
    this.sectionNo,
    this.smallAmount1,
    this.smallAmount2,
    this.smallAmount3,
    this.smallAmount4,
    this.subsectionNo,
    this.zone1,
    this.zone2,
    this.zone3,
    this.zone4,
  });

  OffenceSectionModel.fromJson(Map<String, dynamic> json) {
    actId = json['ActID'];
    amount1 = json['Amount1'];
    amount2 = json['Amount2'];
    amount3 = json['Amount3'];
    amount4 = json['Amount4'];
    description = json['Description'];
    description1 = json['Description1'];
    description2 = json['Description2'];
    description3 = json['Description3'];
    description4 = json['Description4'];
    id = json['ID'];
    maxAmount = json['MaxAmount'];
    resultCode = json['ResultCode'];
    sectionNo = json['SectionNo'];
    smallAmount1 = json['SmallAmount1'];
    smallAmount2 = json['SmallAmount2'];
    smallAmount3 = json['SmallAmount3'];
    smallAmount4 = json['SmallAmount4'];
    subsectionNo = json['SubsectionNo'];
    zone1 = json['Zone1'];
    zone2 = json['Zone2'];
    zone3 = json['Zone3'];
    zone4 = json['Zone4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ActID'] = actId;
    data['Amount1'] = amount1;
    data['Amount2'] = amount2;
    data['Amount3'] = amount3;
    data['Amount4'] = amount4;
    data['Description'] = description;
    data['Description1'] = description1;
    data['Description2'] = description2;
    data['Description3'] = description3;
    data['Description4'] = description4;
    data['ID'] = id;
    data['MaxAmount'] = maxAmount;
    data['ResultCode'] = resultCode;
    data['SectionNo'] = sectionNo;
    data['SmallAmount1'] = smallAmount1;
    data['SmallAmount2'] = smallAmount2;
    data['SmallAmount3'] = smallAmount3;
    data['SmallAmount4'] = smallAmount4;
    data['SubsectionNo'] = subsectionNo;
    data['Zone1'] = zone1;
    data['Zone2'] = zone2;
    data['Zone3'] = zone3;
    data['Zone4'] = zone4;
    return data;
  }
}
