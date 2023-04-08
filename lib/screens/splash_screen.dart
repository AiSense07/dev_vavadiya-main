import 'dart:io';

import 'package:ai_sense/controller/notifier.dart';
import 'package:ai_sense/helper/colors.dart';
import 'package:ai_sense/helper/navigations.dart';
import 'package:ai_sense/screens/admin_modual/admin_home_screen.dart';
import 'package:ai_sense/screens/login_screen.dart';
import 'package:ai_sense/screens/main_screen.dart';
import 'package:ai_sense/screens/popup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controller/shared_preference.dart';
import '../models/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> getUserID(Size size) async {
    String id = await getId();
    if (id != '') {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('main admin')
          .doc("admin id"
              "")
          .collection("user details")
          .doc(id)
          .get();
      UserData data = UserData.fromJson(querySnapshot.data()!);
      if (data.service) {
        await getUserData();
        return true;
      } else {
        disServicePopup(context, size);
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      Size size = MediaQuery.of(context).size;
      await getUserID(size).then((isLogin) async {
        if (isLogin) {
          if (userData.value!.cat == "admin") {
            pushReplacement(const AdminHomeScreen(), context);
          } else {
            if (userData.value!.service) {
              pushReplacement(const MainScreen(), context);
            } else {
              disServicePopup(context, size);
            }
          }
        } else {
          pushReplacement(const LoginScreen(), context);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  // child: Image.asset("assets/logo.png"),
                  ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).padding.bottom + 25),
            child: CircularProgressIndicator(
              color: AppColors.white,
            ),
          )
        ],
      ),
    );
  }
}

disServicePopup(BuildContext context, Size size) async {
  await getMobile().then(
    (value) => showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          actionsPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Service is discontinue.\nPlease contact with your Service handler.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: size.width * 0.045, color: AppColors.white),
              ),
              const SizedBox(height: 5),
              Text(
                "✆  +91 $value",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: size.width * 0.04, color: AppColors.white),
              ),
            ],
          ),
          actions: [
            Container(color: Colors.white70, height: 1),
            Row(
              children: [
                ConfirmationPopupBtn(
                    size: size,
                    title: "Exit",
                    onTap: () {
                      clear();
                      exit(0);
                    },
                    textColor: Colors.white,
                    btnColor: AppColors.primary),
                Container(color: Colors.white70, height: 45, width: 1),
                ConfirmationPopupBtn(
                    size: size,
                    title: "Call now",
                    onTap: () {
                      clear();
                      // pop(context);
                    },
                    textColor: Colors.white,
                    btnColor: AppColors.white38),
              ],
            ),
          ],
        );
      },
    ),
  );
}
