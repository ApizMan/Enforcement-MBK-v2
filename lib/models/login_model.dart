class LoginModel {
  String? userId;
  String? password;
  String? unit;
  String? witness;

  LoginModel({this.userId, this.password, this.unit, this.witness});

  LoginModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    password = json['password'];
    unit = json['unit'];
    witness = json['saksi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['password'] = password;
    data['unit'] = unit;
    data['saksi'] = witness;
    return data;
  }
}
