class OfficerUnitModel {
  String? description;
  String? id;

  OfficerUnitModel({this.description, this.id});

  OfficerUnitModel.fromJson(Map<String, dynamic> json) {
    description = json['Description'];
    id = json['ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Description'] = description;
    data['ID'] = id;
    return data;
  }
}
