import 'package:eo_apk_mbk_v2/models/models.dart';

class OffenceLocationModel {
  String? id;
  String? areaID;
  String? description;
  bool? isDeleted;
  String? createdBy;
  String? updatedBy;
  String? createdDate;
  String? updatedDate;
  int? code;
  int? offenceLocationAreaCode;
  OffenceAreaModel? area;

  OffenceLocationModel(
      {this.id,
      this.areaID,
      this.description,
      this.isDeleted,
      this.createdBy,
      this.updatedBy,
      this.createdDate,
      this.updatedDate,
      this.code,
      this.offenceLocationAreaCode,
      this.area});

  OffenceLocationModel.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    areaID = json['AreaID'];
    description = json['Name'];
    isDeleted = json['IsDeleted'];
    createdBy = json['CreatedBy'];
    updatedBy = json['UpdatedBy'];
    createdDate = json['CreatedDate'];
    updatedDate = json['UpdatedDate'];
    code = json['Code'];
    offenceLocationAreaCode = json['OffenceLocationAreaCode'];
    area =
        json['area'] != null ? OffenceAreaModel.fromJson(json['area']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['AreaID'] = areaID;
    data['Name'] = description;
    data['IsDeleted'] = isDeleted;
    data['CreatedBy'] = createdBy;
    data['UpdatedBy'] = updatedBy;
    data['CreatedDate'] = createdDate;
    data['UpdatedDate'] = updatedDate;
    data['Code'] = code;
    data['OffenceLocationAreaCode'] = offenceLocationAreaCode;
    if (area != null) {
      data['area'] = area!.toJson();
    }
    return data;
  }
}
