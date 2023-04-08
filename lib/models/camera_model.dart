class CameraModel {
  CameraModel({
    this.images,
    this.cameraDetails,
  });

  List<Images?>? images;
  CameraDetails? cameraDetails;

  factory CameraModel.fromJson(Map<String, dynamic> json) => CameraModel(
        images: json["images"] == null ? [] : List<Images>.from(json["images"].map((x) => Images.fromJson(x))),
        cameraDetails: json["cam setting"] == null ? CameraDetails() : CameraDetails.fromJson(json["cam setting"]),
      );
}

class CameraDetails {
  CameraDetails({
    this.startTime,
    this.streaming = true,
    this.calls = true,
    this.name,
    this.endTime,
    this.faceDetection = true,
    this.id,
  });

  String? startTime;
  bool streaming;
  bool calls;
  String? name;
  String? endTime;
  bool faceDetection;
  String? id;

  factory CameraDetails.fromJson(Map<String, dynamic> json) => CameraDetails(
        startTime: json["start_time"],
        streaming: json["streaming"],
        calls: json["calls"],
        name: json["name"] ?? "",
        endTime: json["end_time"],
        faceDetection: json["face_detection"],
        id: json["id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "start_time": startTime,
        "streaming": streaming,
        "calls": calls,
        "name": name,
        "end_time": endTime,
        "face_detection": faceDetection,
        "id": id,
      };
}

class Images {
  Images({
    this.image,
    this.time,
  });

  String? image;
  DateTime? time;

  factory Images.fromJson(Map<String, dynamic> json) => Images(
        image: json["image"] ?? "https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png",
        time: DateTime.parse(json["time"] ?? DateTime.now().toString()),
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "time": time ?? time!.toIso8601String(),
      };
}
