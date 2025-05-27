class VehicleColorModel {
  String? id;
  String? description;
  bool? isDeleted;
  String? createdBy;
  String? updatedBy;
  String? createdDate;
  String? updatedDate;

  VehicleColorModel(
      {this.id,
      this.description,
      this.isDeleted,
      this.createdBy,
      this.updatedBy,
      this.createdDate,
      this.updatedDate});

  VehicleColorModel.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    description = json['Name'];
    isDeleted = json['IsDeleted'];
    createdBy = json['CreatedBy'];
    updatedBy = json['UpdatedBy'];
    createdDate = json['CreatedDate'];
    updatedDate = json['UpdatedDate'];
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
    return data;
  }
}
