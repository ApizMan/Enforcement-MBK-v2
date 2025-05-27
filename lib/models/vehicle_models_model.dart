class VehicleModelsModel {
  String? id;
  String? makeId;
  String? description;
  bool? isDeleted;
  String? createdBy;
  String? updatedBy;
  String? createdDate;
  String? updatedDate;

  VehicleModelsModel(
      {this.id,
      this.makeId,
      this.description,
      this.isDeleted,
      this.createdBy,
      this.updatedBy,
      this.createdDate,
      this.updatedDate});

  VehicleModelsModel.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    makeId = json['MakeID'];
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
    data['MakeID'] = makeId;
    data['Name'] = description;
    data['IsDeleted'] = isDeleted;
    data['CreatedBy'] = createdBy;
    data['UpdatedBy'] = updatedBy;
    data['CreatedDate'] = createdDate;
    data['UpdatedDate'] = updatedDate;
    return data;
  }
}
