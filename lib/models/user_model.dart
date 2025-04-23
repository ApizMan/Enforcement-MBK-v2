class UserModel {
  String? id;
  String? name;
  String? password;
  String? userId;

  UserModel({this.id, this.name, this.password, this.userId});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    name = json['Name'];
    password = json['Password'];
    userId = json['UserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['Name'] = name;
    data['Password'] = password;
    data['UserID'] = userId;
    return data;
  }
}
