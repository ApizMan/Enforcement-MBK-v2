class OfficerCompoundModel {
  int? compoundAmount;
  String? compoundExpiryDateString;
  String? handheldCode;
  String? imageName1;
  String? imageName2;
  String? imageName3;
  String? imageName4;
  String? imageName5;
  bool? isClamping;
  String? notes;
  String? noticeNo;
  int? offenceActCode;
  String? offenceDateString;
  String? offenceLocation;
  String? offenceLocationArea;
  String? offenceLocationDetails;
  int? offenceSectionCode;
  String? officerID;
  String? officerSaksi;
  String? officerUnit;
  String? roadTaxNo;
  String? squarePoleNo;
  String? vehicleColor;
  String? vehicleMakeModel;
  String? vehicleNo;
  String? vehicleType;

  OfficerCompoundModel({
    this.compoundAmount,
    this.compoundExpiryDateString,
    this.handheldCode,
    this.imageName1,
    this.imageName2,
    this.imageName3,
    this.imageName4,
    this.imageName5,
    this.isClamping,
    this.notes,
    this.noticeNo,
    this.offenceActCode,
    this.offenceDateString,
    this.offenceLocation,
    this.offenceLocationArea,
    this.offenceLocationDetails,
    this.offenceSectionCode,
    this.officerID,
    this.officerSaksi,
    this.officerUnit,
    this.roadTaxNo,
    this.squarePoleNo,
    this.vehicleColor,
    this.vehicleMakeModel,
    this.vehicleNo,
    this.vehicleType,
  });

  OfficerCompoundModel.fromJson(Map<String, dynamic> json) {
    compoundAmount = json['CompoundAmount'];
    compoundExpiryDateString = json['CompoundExpiryDateString'];
    handheldCode = json['HandheldCode'];
    imageName1 = json['ImageName1'];
    imageName2 = json['ImageName2'];
    imageName3 = json['ImageName3'];
    imageName4 = json['ImageName4'];
    imageName5 = json['ImageName5'];
    isClamping = json['IsClamping'];
    notes = json['Notes'];
    noticeNo = json['NoticeNo'];
    offenceActCode = json['OffenceActCode'];
    offenceDateString = json['OffenceDateString'];
    offenceLocation = json['OffenceLocation'];
    offenceLocationArea = json['OffenceLocationArea'];
    offenceLocationDetails = json['OffenceLocationDetails'];
    offenceSectionCode = json['OffenceSectionCode'];
    officerID = json['OfficerID'];
    officerSaksi = json['OfficerSaksi'];
    officerUnit = json['OfficerUnit'];
    roadTaxNo = json['RoadTaxNo'];
    squarePoleNo = json['SquarePoleNo'];
    vehicleColor = json['VehicleColor'];
    vehicleMakeModel = json['VehicleMakeModel'];
    vehicleNo = json['VehicleNo'];
    vehicleType = json['VehicleType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CompoundAmount'] = compoundAmount;
    data['CompoundExpiryDateString'] = compoundExpiryDateString;
    data['HandheldCode'] = handheldCode;
    data['ImageName1'] = imageName1;
    data['ImageName2'] = imageName2;
    data['ImageName3'] = imageName3;
    data['ImageName4'] = imageName4;
    data['ImageName5'] = imageName5;
    data['IsClamping'] = isClamping;
    data['Notes'] = notes;
    data['NoticeNo'] = noticeNo;
    data['OffenceActCode'] = offenceActCode;
    data['OffenceDateString'] = offenceDateString;
    data['OffenceLocation'] = offenceLocation;
    data['OffenceLocationArea'] = offenceLocationArea;
    data['OffenceLocationDetails'] = offenceLocationDetails;
    data['OffenceSectionCode'] = offenceSectionCode;
    data['OfficerID'] = officerID;
    data['OfficerSaksi'] = officerSaksi;
    data['OfficerUnit'] = officerUnit;
    data['RoadTaxNo'] = roadTaxNo;
    data['SquarePoleNo'] = squarePoleNo;
    data['VehicleColor'] = vehicleColor;
    data['VehicleMakeModel'] = vehicleMakeModel;
    data['VehicleNo'] = vehicleNo;
    data['VehicleType'] = vehicleType;
    return data;
  }
}
