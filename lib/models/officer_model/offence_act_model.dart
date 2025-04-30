class OffenceActModel {
  String? description;
  String? id;
  String? shortDescription;

  OffenceActModel({this.description, this.id, this.shortDescription});

  OffenceActModel.fromJson(Map<String, dynamic> json) {
    description = json['Description'];
    id = json['ID'];
    shortDescription = json['ShortDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Description'] = description;
    data['ID'] = id;
    data['ShortDescription'] = shortDescription;
    return data;
  }
}
