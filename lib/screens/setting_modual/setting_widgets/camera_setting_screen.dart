import 'package:ai_sense/helper/navigations.dart';
import 'package:ai_sense/screens/setting_modual/setting_widgets/time_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../controller/notifier.dart';
import '../../../helper/colors.dart';
import '../../../helper/custom_switch.dart';
import '../../../helper/widgets.dart';
import '../../../models/camera_model.dart';
import '../camera_on_off_screen.dart';

class CamSettingScreen extends StatefulWidget {
  final CameraDetails camDetail;

  const CamSettingScreen({Key? key, required this.camDetail}) : super(key: key);

  @override
  State<CamSettingScreen> createState() => _CamSettingScreenState();
}

class _CamSettingScreenState extends State<CamSettingScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isStream = true;
  bool isFace = true;
  bool isCall = true;
  String? startTime;
  String? endTime;
  TextEditingController name = TextEditingController();

  updateCall() async {
    loading.value = true;
    Map<String, dynamic> data = {
      "cam setting": {
        "id": widget.camDetail.id!,
        "calls": isCall,
        "face_detection": isFace,
        "streaming": isStream,
        "name": name.text,
        "start_time": startTime,
        "end_time": endTime,
      },
    };
    await firestore.collection('main admin').doc('admin id').collection(userId.value).doc(widget.camDetail.id!).update(data);
    QuerySnapshot<Map<String, dynamic>> newData = await firestore
        .collection('main admin')
        .doc('admin id'
            '')
        .collection(userId.value)
        .get();
    final listData = newData.docs;
    cameraList.value = [];
    for (var cam in listData) {
      CameraModel cameraModel = CameraModel.fromJson(cam.data());
      cameraList.value.add(cameraModel);
    }
    // if (newData.data() != null) userData.value = UserData.fromJson(newData.data()!);
    loading.value = false;
    pop(context);
  }

  @override
  void initState() {
    debugPrint("==>> ${widget.camDetail.streaming}");
    isStream = widget.camDetail.streaming;
    isFace = widget.camDetail.faceDetection;
    isCall = widget.camDetail.calls;
    startTime = widget.camDetail.startTime;
    endTime = widget.camDetail.endTime;
    name.text = widget.camDetail.name ?? "";
    debugPrint("====>>> startTime $startTime");
    debugPrint("====>>> startTime $endTime");
    super.initState();
  }

  @override
  void dispose() {
    loading.value = false;
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    loading.value = false;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text(
            "${widget.camDetail.name!} setting",
            style: TextStyle(fontWeight: FontWeight.w700),
          )),
      body: ValueListenableBuilder(
          valueListenable: loading,
          builder: (BuildContext context, bool loading, Widget? child) {
            Color white = loading ? AppColors.white38 : AppColors.white;
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 20),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.camDetail.name} setting",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: size.width * 0.05,
                          color: white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      rowWidget(
                          color: white,
                          widget: StyledSwitch(
                            onToggled: () {
                              setState(() {
                                isStream = !isStream;
                              });
                            },
                            isSelect: isStream,
                          ),
                          size: size,
                          title: "Streaming"),
                      rowWidget(
                          color: white,
                          widget: StyledSwitch(
                              onToggled: () {
                                setState(() {
                                  isFace = !isFace;
                                });
                              },
                              isSelect: isFace),
                          size: size,
                          title: "Face Detection"),
                      rowWidget(
                          color: white,
                          widget: StyledSwitch(
                              onToggled: () {
                                setState(() {
                                  isCall = !isCall;
                                });
                              },
                              isSelect: isCall),
                          size: size,
                          title: "Calls"),
                      const SizedBox(height: 15),
                      Text(
                        "Camera Name",
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w500,
                          color: white,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15, bottom: 5),
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: TextFormField(
                          controller: name,
                          style: TextStyle(color: white),
                          decoration: const InputDecoration(
                              enabledBorder: InputBorder.none, border: InputBorder.none, hintText: "Enter Camera Name", hintStyle: TextStyle(color: AppColors.white38)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Set Time range for Alert",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: size.width * 0.045,
                          color: white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TimeContainer(
                              color: white,
                              title: "From",
                              time: startTime,
                              onTap: (value) {
                                setState(() {
                                  startTime = value;
                                });
                                debugPrint(value);
                              }),
                          TimeContainer(
                              color: white,
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
                      const SizedBox(height: 20),
                      customBtn(
                          size: size,
                          name: "Save",
                          onTap: () async {
                            await updateCall();
                            // pop(context);
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
