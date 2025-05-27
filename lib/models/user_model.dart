class UserModel {
  String? id;
  String? groupId;
  String? userId;
  String? fullName;
  String? password;
  bool? isDeleted;
  String? createdBy;
  String? updatedBy;
  String? createdDate;
  String? updatedDate;

  UserModel(
      {this.id,
      this.groupId,
      this.userId,
      this.fullName,
      this.password,
      this.isDeleted,
      this.createdBy,
      this.updatedBy,
      this.createdDate,
      this.updatedDate});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    groupId = json['GroupID'];
    userId = json['UserID'];
    fullName = json['FullName'];
    password = json['Password'];
    isDeleted = json['IsDeleted'];
    createdBy = json['CreatedBy'];
    updatedBy = json['UpdatedBy'];
    createdDate = json['CreatedDate'];
    updatedDate = json['UpdatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['GroupID'] = groupId;
    data['UserID'] = userId;
    data['FullName'] = fullName;
    data['Password'] = password;
    data['IsDeleted'] = isDeleted;
    data['CreatedBy'] = createdBy;
    data['UpdatedBy'] = updatedBy;
    data['CreatedDate'] = createdDate;
    data['UpdatedDate'] = updatedDate;
    return data;
  }
}
