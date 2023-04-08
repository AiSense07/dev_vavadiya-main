import 'package:ai_sense/controller/shared_preference.dart';
import 'package:ai_sense/helper/colors.dart';
import 'package:ai_sense/helper/navigations.dart';
import 'package:ai_sense/helper/widgets.dart';
import 'package:ai_sense/models/user_model.dart';
import 'package:ai_sense/models/user_model.dart';
import 'package:ai_sense/screens/admin_modual/add_user_screen.dart';
import 'package:ai_sense/screens/login_screen.dart';
import 'package:ai_sense/screens/popup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../controller/notifier.dart';
import '../../helper/custom_switch.dart';
import '../../models/camera_model.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  Future getUserList() async {
    loading.value = true;
    final querySnapshot =
        await FirebaseFirestore.instance.collection('main admin').doc("admin id").collection("user details").get();
    userList.value = [];
    for (var data in querySnapshot.docs) {
      if (data.data()['cat'] != "admin") {
        debugPrint("==>> data ${data.data()}");
        UserData cameraModel = UserData.fromJson(data.data());
        userList.value.add(cameraModel);
      }
    }
    loading.value = false;
  }

  Future updateService({required String userId, required bool service}) async {
    serviceLoading.value = true;
    await FirebaseFirestore.instance
        .collection('main admin')
        .doc("admin id")
        .collection("user details")
        .doc(userId)
        .update({"service": service});
    final querySnapshot =
        await FirebaseFirestore.instance.collection('main admin').doc("admin id").collection("user details").get();
    userList.value = [];
    for (var data in querySnapshot.docs) {
      if (data.data()['cat'] != "admin") {
        debugPrint("==>> data ${data.data()}");
        UserData cameraModel = UserData.fromJson(data.data());
        userList.value.add(cameraModel);
      }
    }
    serviceLoading.value = false;
  }

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        await getUserList();
      },
    );
    super.initState();
  }

  bool calls = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          right: size.width * 0.05,
          left: size.width * 0.05,
          bottom: MediaQuery.of(context).padding.bottom + 10,
          top: 10,
        ),
        child: customBtn(size: size, name: "Add User", onTap: () {
          push(AddUserScreen(length: userList.value.length), context);
        }),
      ),
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            onPressed: () {
              clear();
              pushReplacement(const LoginScreen(), context);
            },
            icon: Icon(Icons.logout, color: AppColors.white),
          ),
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: loading,
          builder: (BuildContext context, bool loading, Widget? child) {
            return Stack(
              children: [
                loading
                    ? Center(
                        child: Image.asset("assets/loading.gif", height: 130),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "User details",
                                style: TextStyle(
                                  fontSize: size.width * 0.05,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                              ListView.builder(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shrinkWrap: true,
                                itemCount: userList.value.length,
                                itemBuilder: (context, index) {
                                  UserData data = userList.value[index];
                                  return Container(
                                    padding: const EdgeInsets.all(15),
                                    margin: const EdgeInsets.only(bottom: 15),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white60),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.5,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.name ?? "User",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: size.width * 0.04,
                                                    color: AppColors.white),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                "+91 ${data.call ?? ""}",
                                                style: TextStyle(
                                                  fontSize: size.width * 0.03,
                                                  color: AppColors.white70,
                                                ),
                                              ),
                                              Text(
                                                data.email ?? "",
                                                style: TextStyle(
                                                  fontSize: size.width * 0.03,
                                                  color: AppColors.white70,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 8),
                                            color: Colors.transparent,
                                            width: size.width * 0.12,
                                            height: size.width * 0.12,
                                            child: Icon(Icons.call, color: AppColors.white),
                                          ),
                                        ),
                                        StyledSwitch(
                                          onToggled: () async {
                                            popup(
                                              size: size,
                                              context: context,
                                              title:
                                                  "Are sure want to ${data.service ? "Stop" : "Start"} Camera service for ${data.name}?",
                                              onYesTap: () async {
                                                await updateService(userId: data.id!, service: !data.service);
                                                setState(() {
                                                  data.service = !data.service;
                                                });
                                              },
                                            );
                                            // await updateCall(calls);
                                          },
                                          isSelect: data.service,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                ValueListenableBuilder(
                    valueListenable: serviceLoading,
                    builder: (BuildContext context, bool service, Widget? child) {
                      return serviceLoading.value
                          ? Center(
                              child: Image.asset("assets/loading.gif", height: 130),
                            )
                          : const SizedBox();
                    })
              ],
            );
          }),
    );
  }
}
