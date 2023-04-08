import 'package:ai_sense/controller/notifier.dart';
import 'package:ai_sense/helper/colors.dart';
import 'package:ai_sense/helper/navigations.dart';
import 'package:ai_sense/helper/widgets.dart';
import 'package:ai_sense/models/camera_model.dart';
import 'package:ai_sense/models/user_model.dart';
import 'package:ai_sense/screens/setting_modual/setting_widgets/camera_setting_screen.dart';
import 'package:ai_sense/screens/setting_modual/setting_widgets/time_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../helper/custom_switch.dart';

class CameraOnOffScreen extends StatefulWidget {
  const CameraOnOffScreen({Key? key}) : super(key: key);

  @override
  State<CameraOnOffScreen> createState() => _CameraOnOffScreenState();
}

class _CameraOnOffScreenState extends State<CameraOnOffScreen> {
  String? start;
  String? end;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  updateCall() async {
    loading.value = true;
    Map<String, dynamic> data = {
      "cam setting": {
        "calls": userData.value!.camSetting!.calls,
        "start_time": start ?? "00 : 00 AM",
        "end_time": end ?? "00 : 00 AM",
      },
    };
    await firestore.collection('main admin').doc('admin id').collection("user details").doc(userId.value).update(data);
    DocumentSnapshot<Map<String, dynamic>> newData = await firestore.collection('main admin').doc('admin id').collection("user details").doc(userId.value).get();
    final listData = newData.data();
    userData.value = UserData.fromJson(listData!);
    loading.value = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    UserData? data = userData.value;
    start = data!.camSetting!.startTime;
    end = data.camSetting!.endTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("==>>> start $start");
    debugPrint("==>>> end $end");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text(
            "Cameras",
            style: TextStyle(fontWeight: FontWeight.w700),
          )),
      backgroundColor: Colors.black,
      body: ValueListenableBuilder(
          valueListenable: loading,
          builder: (BuildContext context, bool loading, Widget? child) {
            Color white = loading ? AppColors.white38 : AppColors.white;
            return Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Set Time range for Alert",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: size.width * 0.048,
                          color: AppColors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TimeContainer(
                              color: white,
                              title: "From",
                              time: start,
                              onTap: (value) {
                                setState(() {
                                  start = value;
                                });
                                debugPrint(value);
                              }),
                          TimeContainer(
                              color: white,
                              title: "To",
                              time: end,
                              onTap: (value) {
                                setState(() {
                                  end = value;
                                });
                                debugPrint(value);
                              }),
                        ],
                      ),
                      Text(
                        "Other camera setting",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: size.width * 0.048,
                          color: white,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cameraList.value.length,
                        itemBuilder: (context, index) {
                          CameraDetails cam = cameraList.value[index].cameraDetails ?? CameraDetails();
                          return rowWidget(
                              color: white,
                              widget: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.white),
                              size: size,
                              title: cam.name ?? "",
                              onTap: () {
                                push(CamSettingScreen(camDetail: cam), context);
                              });
                        },
                      ),
                      const SizedBox(height: 25),
                      customBtn(
                          size: size,
                          name: "Save",
                          onTap: () async {
                            await updateCall();
                            pop(context);
                          })
                    ],
                  ),
                ),
                if (loading)
                  Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    width: size.width,
                    height: size.height * 0.8,
                    child: Image.asset("assets/loading.gif", height: 130),
                  )
              ],
            );
          }),
    );
  }
}

Widget rowWidget({required Widget widget, required Size size, required String title, Function? onTap, Color? color}) {
  return GestureDetector(
    onTap: () {
      if (onTap != null) onTap();
    },
    child: Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.w500,
              color: color ?? AppColors.white,
            ),
          ),
          widget
        ],
      ),
    ),
  );
}
