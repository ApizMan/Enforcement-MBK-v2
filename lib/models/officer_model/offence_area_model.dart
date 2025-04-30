class OffenceAreaModel {
  String? description;
  String? id;

  OffenceAreaModel({this.description, this.id});

  OffenceAreaModel.fromJson(Map<String, dynamic> json) {
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
