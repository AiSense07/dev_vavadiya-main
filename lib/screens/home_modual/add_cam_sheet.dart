import 'package:ai_sense/helper/navigations.dart';
import 'package:ai_sense/helper/snackbar.dart';
import 'package:ai_sense/helper/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../controller/notifier.dart';
import '../../helper/colors.dart';
import '../../models/camera_model.dart';
import '../setting_modual/setting_widgets/time_container.dart';

class AddCamSheet extends StatefulWidget {
  const AddCamSheet({Key? key}) : super(key: key);

  @override
  State<AddCamSheet> createState() => _AddCamSheetState();
}

class _AddCamSheetState extends State<AddCamSheet> {
  Future addCam({String? start, String? end, required String name}) async {
    loading.value = true;
    Map<String, dynamic> data = {
      "images": [],
      "cam setting": {
        "calls": true,
        "end_time": end ?? "06 : 00 AM",
        "face_detection": true,
        "id": "cam ${cameraList.value.length + 1} id",
        "name": name,
        "start_time": start ?? "12 : 00 AM",
        "streaming": true,
      }
    };

    await FirebaseFirestore.instance
        .collection('main admin')
        .doc("admin id"
            "")
        .collection(userId.value)
        .doc("cam ${cameraList.value.length + 1} id")
        .set(data);
    final querySnapshot = await FirebaseFirestore.instance.collection('main admin').doc("admin id").collection(userId.value).get();
    cameraList.value = [];
    for (var data in querySnapshot.docs) {
      CameraModel cameraModel = CameraModel.fromJson(data.data());
      cameraList.value.add(cameraModel);
    }
    loading.value = false;
    pop(context);
  }

  String? startTime;
  String? endTime;
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Camera"), backgroundColor: AppColors.primary),
      backgroundColor: Colors.black,
      body: ValueListenableBuilder(
          valueListenable: loading,
          builder: (BuildContext context, bool loading, Widget? child) {
            return loading
                ? Center(child: Image.asset("assets/loading.gif", height: 130))
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Scan Camera QR",
                          style: TextStyle(fontSize: size.width * 0.042, fontWeight: FontWeight.w500, color: AppColors.white),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.only(top: 10, bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.white70),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.qr_code_scanner_outlined, color: AppColors.white70),
                                const SizedBox(width: 15),
                                Text(
                                  "Tap to scan",
                                  style: TextStyle(
                                    fontSize: size.width * 0.042,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          "Camera Name",
                          style: TextStyle(
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15, bottom: 5),
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.white70),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            controller: name,
                            style: TextStyle(color: AppColors.white),
                            cursorColor: AppColors.white70,
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              hintText: "Enter Camera Name",
                              hintStyle: TextStyle(color: AppColors.white60),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Set Time range for Alert",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: size.width * 0.045,
                            color: AppColors.white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TimeContainer(
                                color: AppColors.white,
                                title: "From",
                                time: startTime,
                                onTap: (value) {
                                  setState(() {
                                    startTime = value;
                                  });
                                  debugPrint(value);
                                }),
                            TimeContainer(
                                color: AppColors.white,
                                title: "To",
                                time: endTime,
                                onTap: (value) {
                                  setState(() {
                                    endTime = value;
                                  });
                                  debugPrint(value);
                                }),
                          ],
                        ),
                        customBtn(
                          size: size,
                          name: "Add",
                          onTap: () async {
                            if (name.text.isNotEmpty) {
                              await addCam(name: name.text, end: endTime, start: startTime);
                            } else {
                              snackBar(msg: "Please add camera name", context: context, isError: true);
                            }
                          },
                        ),
                      ],
                    ),
                  );
          }),
    );
  }
}
