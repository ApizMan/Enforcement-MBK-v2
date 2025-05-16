class OfficerCompoundModel {
  String? noticeNo;
  String? vehicleNo;
  String? offenceDateString;
  String? officerId;
  String? handheldCode;
  String? vehicleType;
  String? vehicleMakeModel;
  String? vehicleColor;
  String? roadTaxNo;
  String? offenceSectionCode;
  String? offenceArea;
  String? offenceLocation;
  String? offenceLocationDetails;
  int? compoundAmount;
  String? imageName1;
  String? imageName2;
  String? imageName3;
  String? imageName4;
  String? imageName5;
  bool? isClamping;
  String? notes;
  String? officerUnit;
  double? latitude;
  double? longitude;
  String? squarePoleNo;
  String? officerSaksi;

  OfficerCompoundModel(
      {this.noticeNo,
      this.vehicleNo,
      this.offenceDateString,
      this.officerId,
      this.handheldCode,
      this.vehicleType,
      this.vehicleMakeModel,
      this.vehicleColor,
      this.roadTaxNo,
      this.offenceSectionCode,
      this.offenceArea,
      this.offenceLocation,
      this.offenceLocationDetails,
      this.compoundAmount,
      this.imageName1,
      this.imageName2,
      this.imageName3,
      this.imageName4,
      this.imageName5,
      this.isClamping,
      this.notes,
      this.officerUnit,
      this.latitude,
      this.longitude,
      this.squarePoleNo,
      this.officerSaksi});

  OfficerCompoundModel.fromJson(Map<String, dynamic> json) {
    noticeNo = json['NoticeNo'];
    vehicleNo = json['VehicleNo'];
    offenceDateString = json['OffenceDateString'];
    officerId = json['OfficerID'];
    handheldCode = json['HandheldCode'];
    vehicleType = json['VehicleType'];
    vehicleMakeModel = json['VehicleMakeModel'];
    vehicleColor = json['VehicleColor'];
    roadTaxNo = json['RoadTaxNo'];
    offenceSectionCode = json['OffenceSectionCode'];
    offenceArea = json['OffenceArea'];
    offenceLocation = json['OffenceLocation'];
    offenceLocationDetails = json['OffenceLocationDetails'];
    compoundAmount = json['CompoundAmount'];
    imageName1 = json['ImageName1'];
    imageName2 = json['ImageName2'];
    imageName3 = json['ImageName3'];
    imageName4 = json['ImageName4'];
    imageName5 = json['ImageName5'];
    isClamping = json['IsClamping'];
    notes = json['Notes'];
    officerUnit = json['OfficerUnit'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    squarePoleNo = json['SquarePoleNo'];
    officerSaksi = json['OfficerSaksi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['NoticeNo'] = noticeNo;
    data['VehicleNo'] = vehicleNo;
    data['OffenceDateString'] = offenceDateString;
    data['OfficerID'] = officerId;
    data['HandheldCode'] = handheldCode;
    data['VehicleType'] = vehicleType;
    data['VehicleMakeModel'] = vehicleMakeModel;
    data['VehicleColor'] = vehicleColor;
    data['RoadTaxNo'] = roadTaxNo;
    data['OffenceSectionCode'] = offenceSectionCode;
    data['OffenceArea'] = offenceArea;
    data['OffenceLocation'] = offenceLocation;
    data['OffenceLocationDetails'] = offenceLocationDetails;
    data['CompoundAmount'] = compoundAmount;
    data['ImageName1'] = imageName1;
    data['ImageName2'] = imageName2;
    data['ImageName3'] = imageName3;
    data['ImageName4'] = imageName4;
    data['ImageName5'] = imageName5;
    data['IsClamping'] = isClamping;
    data['Notes'] = notes;
    data['OfficerUnit'] = officerUnit;
    data['Latitude'] = latitude;
    data['Longitude'] = longitude;
    data['SquarePoleNo'] = squarePoleNo;
    data['OfficerSaksi'] = officerSaksi;
    return data;
  }
}
