class VehicleModel {
  String? id;
  String? plate;
  String? zone;
  String? terminalno;
  String? creationdate;
  String? creationtime;
  String? startdate;
  String? starttime;
  String? enddate;
  String? endtime;
  String? remotecalltime;
  String? duration;
  String? noofday;

  VehicleModel({
    this.id,
    this.plate,
    this.zone,
    this.terminalno,
    this.creationdate,
    this.creationtime,
    this.startdate,
    this.starttime,
    this.enddate,
    this.endtime,
    this.remotecalltime,
    this.duration,
    this.noofday,
  });

  VehicleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plate = json['plate'];
    zone = json['zone'];
    terminalno = json['terminalno'];
    creationdate = json['creationdate'];
    creationtime = json['creationtime'];
    startdate = json['startdate'];
    starttime = json['starttime'];
    enddate = json['enddate'];
    endtime = json['endtime'];
    remotecalltime = json['remotecalltime'];
    duration = json['duration'];
    noofday = json['noofday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['plate'] = plate;
    data['zone'] = zone;
    data['terminalno'] = terminalno;
    data['creationdate'] = creationdate;
    data['creationtime'] = creationtime;
    data['startdate'] = startdate;
    data['starttime'] = starttime;
    data['enddate'] = enddate;
    data['endtime'] = endtime;
    data['remotecalltime'] = remotecalltime;
    data['duration'] = duration;
    data['noofday'] = noofday;
    return data;
  }
}
