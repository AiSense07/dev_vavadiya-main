import 'package:ai_sense/controller/notifier.dart';
import 'package:ai_sense/controller/shared_preference.dart';
import 'package:ai_sense/helper/colors.dart';
import 'package:ai_sense/helper/custom_switch.dart';
import 'package:ai_sense/helper/navigations.dart';
import 'package:ai_sense/helper/widgets.dart';
import 'package:ai_sense/models/user_model.dart';
import 'package:ai_sense/screens/login_screen.dart';
import 'package:ai_sense/screens/setting_modual/camera_on_off_screen.dart';
import 'package:ai_sense/screens/setting_modual/setting_widgets/add_mobile_popup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController pass = TextEditingController();
  TextEditingController comPass = TextEditingController();

  bool notification = true;
  bool calls = true;

  updateCall(bool calls) async {
    debugPrint("===>>>  call $calls");
    loading.value = true;
    Map<String, dynamic> data = {
      "cam setting": {
        "calls": calls,
        "start_time": userData.value!.camSetting!.startTime.toString(),
        "end_time": userData.value!.camSetting!.endTime.toString(),
      },
    };
    setState(() {
      calls = !calls;
    });
    await firestore.collection('main admin').doc('admin id').collection("user details").doc(userId.value).update(data);
    DocumentSnapshot<Map<String, dynamic>> newData = await firestore
        .collection('main admin')
        .doc('admin id'
            '')
        .collection("user details")
        .doc(userId.value)
        .get();
    if (newData.data() != null) userData.value = UserData.fromJson(newData.data()!);
    loading.value = false;
  }

  updatePass(String pass) async {
    loading.value = true;
    debugPrint("==>> pass $pass");
    Map<String, dynamic> data = {
      "pass": pass,
    };
    await firestore.collection('main admin').doc('admin id').collection("user details").doc(userId.value).update(data);
    loading.value = false;
  }

  String password = '';
  String comPassword = '';

  @override
  void initState() {
    setState(() {
      calls = userData.value!.camSetting!.calls;
      debugPrint("===>>>  call init ${userData.value!.toJson()}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: size.width,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 15,
            bottom: 15,
            right: size.width * 0.05,
            left: size.width * 0.05,
          ),
          color: AppColors.primary,
          child: Text(
            "Settings",
            style: TextStyle(
              fontSize: size.width * 0.055,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
        ValueListenableBuilder(
            valueListenable: loading,
            builder: (BuildContext context, bool loading, Widget? child) {
              Color white = loading ? AppColors.white38 : AppColors.white;
              return Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          rowWidget(
                              color: white,
                              widget: StyledSwitch(
                                onToggled: () async {
                                  setState(() {
                                    calls = !calls;
                                  });
                                  await updateCall(calls);
                                },
                                isSelect: calls,
                              ),
                              size: size,
                              title: "Calls"),
                          rowWidget(
                            color: white,
                            onTap: () {
                              push(const CameraOnOffScreen(), context);
                            },
                            widget: Icon(Icons.arrow_forward_ios_rounded, color: white),
                            size: size,
                            title: "Camera setting",
                          ),
                          /*rowWidget(
                            color: white,
                            onTap: () {
                              showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                ),
                                context: context,
                                backgroundColor: AppColors.primary,
                                builder: (context) {
                                  return const AddMobile();
                                },
                              );
                            },
                            widget: Icon(Icons.arrow_forward_ios_rounded,
                                color: white),
                            size: size,
                            title: "Add alternative number",
                          ),*/
                          rowWidget(
                            color: white,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    backgroundColor: AppColors.primary,
                                    titlePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                                    title: Column(
                                      children: [
                                        CustomTextField(
                                            onChange: (value) {
                                              setState(() {
                                                password = value;
                                              });
                                            },
                                            hint: "Enter Password",
                                            title: "Password",
                                            controller: pass,
                                            size: size),
                                        CustomTextField(
                                          onChange: (value) {
                                            setState(() {
                                              comPassword = value;
                                            });
                                          },
                                          hint: "Re-enter Password",
                                          title: "Confirm Password",
                                          controller: comPass,
                                          size: size,
                                        ),
                                        const SizedBox(height: 20),
                                        customBtn(
                                            size: size,
                                            name: "Change password",
                                            onTap: () async {
                                              if (pass.text == comPass.text) {
                                                pop(context);
                                                await updatePass(password);
                                              }
                                            })
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            widget: Icon(Icons.arrow_forward_ios_rounded, color: white),
                            size: size,
                            title: "Forgot password",
                          ),
                          rowWidget(
                            color: white,
                            onTap: () {
                              clear();
                              pushReplacement(const LoginScreen(), context);
                            },
                            widget: Icon(Icons.logout, color: white),
                            size: size,
                            title: "Logout",
                          ),
                        ],
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
                  ),
                ),
              );
            }),
      ],
    );
  }

  Widget rowWidget({required Widget widget, required Size size, required String title, Function? onTap, required Color color}) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap();
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            widget
          ],
        ),
      ),
    );
  }
}
