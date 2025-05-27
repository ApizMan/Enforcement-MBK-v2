class OffenceAreaModel {
  String? id;
  String? description;
  bool? isDeleted;
  String? createdBy;
  String? updatedBy;
  String? createdDate;
  String? updatedDate;
  int? code;

  OffenceAreaModel(
      {this.id,
      this.description,
      this.isDeleted,
      this.createdBy,
      this.updatedBy,
      this.createdDate,
      this.updatedDate,
      this.code});

  OffenceAreaModel.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    description = json['Name'];
    isDeleted = json['IsDeleted'];
    createdBy = json['CreatedBy'];
    updatedBy = json['UpdatedBy'];
    createdDate = json['CreatedDate'];
    updatedDate = json['UpdatedDate'];
    code = json['Code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['Name'] = description;
    data['IsDeleted'] = isDeleted;
    data['CreatedBy'] = createdBy;
    data['UpdatedBy'] = updatedBy;
    data['CreatedDate'] = createdDate;
    data['UpdatedDate'] = updatedDate;
    data['Code'] = code;
    return data;
  }
}
