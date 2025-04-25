class VehicleModelsModel {
  String? description;
  String? id;
  String? makeId;

  VehicleModelsModel({this.description, this.id, this.makeId});

  VehicleModelsModel.fromJson(Map<String, dynamic> json) {
    description = json['Description'];
    id = json['ID'];
    makeId = json['MakeID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Description'] = description;
    data['ID'] = id;
    data['MakeID'] = makeId;
    return data;
  }
}
