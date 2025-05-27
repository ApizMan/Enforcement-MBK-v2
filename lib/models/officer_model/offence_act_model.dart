class OffenceActModel {
  String? id;
  int? code;
  String? shortDescription;
  String? description;
  bool? isDeleted;
  String? createdBy;
  String? updatedBy;
  String? createdDate;
  String? updatedDate;

  OffenceActModel(
      {this.id,
      this.code,
      this.shortDescription,
      this.description,
      this.isDeleted,
      this.createdBy,
      this.updatedBy,
      this.createdDate,
      this.updatedDate});

  OffenceActModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    shortDescription = json['short_description'];
    description = json['description'];
    isDeleted = json['is_deleted'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['short_description'] = shortDescription;
    data['description'] = description;
    data['is_deleted'] = isDeleted;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['created_date'] = createdDate;
    data['updated_date'] = updatedDate;
    return data;
  }
}
