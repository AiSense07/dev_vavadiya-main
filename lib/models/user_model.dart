class UserData {
  UserData({
    this.camSetting,
    this.name,
    this.email,
    this.pass,
    this.id,
    this.cat,
    this.call,
    this.service = true,
  });

  CamSetting? camSetting;
  String? name;
  String? email;
  String? pass;
  String? id;
  String? cat;
  String? call;
  bool service;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        camSetting: json["cam setting"] == null ? CamSetting() : CamSetting.fromJson(json["cam setting"]),
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        pass: json["pass"],
        id: json["id"] ?? "",
        cat: json["cat"] ?? "",
        call: json["call"] ?? "",
        service: json["service"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "cam setting": camSetting!.toJson(),
        "name": name,
        "email": email,
        "pass": pass,
        "id": id,
        "cat": cat,
        "call": call,
        "service": service,
      };
}

class CamSetting {
  CamSetting({
    this.calls = true,
    this.startTime,
    this.endTime,
  });

  bool calls;
  String? startTime;
  String? endTime;

  factory CamSetting.fromJson(Map<String, dynamic> json) => CamSetting(
        calls: json["calls"],
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toJson() => {
        "calls": calls,
        "start_time": startTime,
        "end_time": endTime,
      };
}
