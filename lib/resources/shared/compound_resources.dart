import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';

class CompoundResourcesSharedPreferences {
  List<OfficerCompoundModel> compoundList = [];

  Future<void> getCompoundParkingData() async {
    compoundList = await SharedPreferencesHelper.getAllOfficerCompoundModels();
  }

  List<List<Map<String, String?>>> getDataSets() {
    return compoundList.map((compoundData) {
      return [
        {'label': 'Notice No', 'value': compoundData.noticeNo},
        {'label': 'Vehicle No', 'value': compoundData.vehicleNo},
        {'label': 'Offence Date', 'value': compoundData.offenceDateString},
        {'label': 'Officer ID', 'value': compoundData.officerId},
        {'label': 'Handheld Code', 'value': compoundData.handheldCode},
        {'label': 'Vehicle Type', 'value': compoundData.vehicleType},
        {'label': 'Make/Model', 'value': compoundData.vehicleMakeModel},
        {'label': 'Color', 'value': compoundData.vehicleColor},
        {'label': 'Road Tax No', 'value': compoundData.roadTaxNo},
        {'label': 'Section Code', 'value': compoundData.offenceSectionCode},
        {'label': 'Area', 'value': compoundData.offenceArea},
        {'label': 'Location', 'value': compoundData.offenceLocation},
        {'label': 'Details', 'value': compoundData.offenceLocationDetails},
        {
          'label': 'Compound Amount',
          'value': compoundData.compoundAmount?.toString()
        },
        {'label': 'Image 1', 'value': compoundData.imageName1},
        {'label': 'Image 2', 'value': compoundData.imageName2},
        {'label': 'Image 3', 'value': compoundData.imageName3},
        {'label': 'Image 4', 'value': compoundData.imageName4},
        {'label': 'Image 5', 'value': compoundData.imageName5},
        {
          'label': 'Is Clamping',
          'value': compoundData.isClamping == true ? 'Yes' : 'No'
        },
        {'label': 'Notes', 'value': compoundData.notes},
        {'label': 'Officer Unit', 'value': compoundData.officerUnit},
        {'label': 'Latitude', 'value': compoundData.latitude?.toString()},
        {'label': 'Longitude', 'value': compoundData.longitude?.toString()},
        {'label': 'Square Pole No', 'value': compoundData.squarePoleNo},
        {'label': 'Saksi', 'value': compoundData.officerSaksi},
      ];
    }).toList();
  }
}
