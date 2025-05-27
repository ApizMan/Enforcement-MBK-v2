class OffenceSectionModel {
  String? id;
  String? actId;
  int? code;
  String? sectionNo;
  String? subsectionNo;
  String? description;
  int? zone1;
  int? zone2;
  int? zone3;
  int? zone4;
  int? smallAmount1;
  int? smallAmount2;
  int? smallAmount3;
  int? smallAmount4;
  int? amount1;
  int? amount2;
  int? amount3;
  int? amount4;
  String? description1;
  String? description2;
  String? description3;
  String? description4;
  int? maxAmount;
  String? resultCode;
  bool? isDeleted;
  String? createdBy;
  String? updatedBy;
  String? createdDate;
  String? updatedDate;

  OffenceSectionModel(
      {this.id,
      this.actId,
      this.code,
      this.sectionNo,
      this.subsectionNo,
      this.description,
      this.zone1,
      this.zone2,
      this.zone3,
      this.zone4,
      this.smallAmount1,
      this.smallAmount2,
      this.smallAmount3,
      this.smallAmount4,
      this.amount1,
      this.amount2,
      this.amount3,
      this.amount4,
      this.description1,
      this.description2,
      this.description3,
      this.description4,
      this.maxAmount,
      this.resultCode,
      this.isDeleted,
      this.createdBy,
      this.updatedBy,
      this.createdDate,
      this.updatedDate});

  OffenceSectionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    actId = json['act_id'];
    code = json['code'];
    sectionNo = json['section_no'];
    subsectionNo = json['sub_section_no'];
    description = json['description'];
    zone1 = json['zone1'];
    zone2 = json['zone2'];
    zone3 = json['zone3'];
    zone4 = json['zone4'];
    smallAmount1 = json['small_amount1'];
    smallAmount2 = json['small_amount2'];
    smallAmount3 = json['small_amount3'];
    smallAmount4 = json['small_amount4'];
    amount1 = json['amount1'];
    amount2 = json['amount2'];
    amount3 = json['amount3'];
    amount4 = json['amount4'];
    description1 = json['desc1'];
    description2 = json['desc2'];
    description3 = json['desc3'];
    description4 = json['desc4'];
    maxAmount = json['max_amount'];
    resultCode = json['result_code'];
    isDeleted = json['is_deleted'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['act_id'] = actId;
    data['code'] = code;
    data['section_no'] = sectionNo;
    data['sub_section_no'] = subsectionNo;
    data['description'] = description;
    data['zone1'] = zone1;
    data['zone2'] = zone2;
    data['zone3'] = zone3;
    data['zone4'] = zone4;
    data['small_amount1'] = smallAmount1;
    data['small_amount2'] = smallAmount2;
    data['small_amount3'] = smallAmount3;
    data['small_amount4'] = smallAmount4;
    data['amount1'] = amount1;
    data['amount2'] = amount2;
    data['amount3'] = amount3;
    data['amount4'] = amount4;
    data['desc1'] = description1;
    data['desc2'] = description2;
    data['desc3'] = description3;
    data['desc4'] = description4;
    data['max_amount'] = maxAmount;
    data['result_code'] = resultCode;
    data['is_deleted'] = isDeleted;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['created_date'] = createdDate;
    data['updated_date'] = updatedDate;
    return data;
  }
}
