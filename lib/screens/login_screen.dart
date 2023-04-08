import 'dart:io';

import 'package:ai_sense/controller/notifier.dart';
import 'package:ai_sense/helper/navigations.dart';
import 'package:ai_sense/helper/snackbar.dart';
import 'package:ai_sense/helper/widgets.dart';
import 'package:ai_sense/models/user_model.dart';
import 'package:ai_sense/screens/admin_modual/admin_home_screen.dart';
import 'package:ai_sense/screens/home_modual/home_screen.dart';
import 'package:ai_sense/screens/popup.dart';
import 'package:ai_sense/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controller/shared_preference.dart';
import '../helper/colors.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHide = false;

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future checkEmail(String email) async {
    emailLoading.value = true;
    isEmailExist.value = false;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('main admin')
        .doc("admin id"
            "")
        .collection("user details")
        .get();
    for (final documentSnapshot in querySnapshot.docs) {
      UserData data = UserData.fromJson(documentSnapshot.data());
      debugPrint("email === $email ==${data.email}");
      if (data.cat == "admin") {
        setMobile(data.call!);
      }
      if (data.email == email) {
        // debugPrint("done email === >> ${documentSnapshot.data()}");
        setUserData(data);
        isEmailExist.value = true;
        return true;
        // break;
      } else {
        if (querySnapshot.docs.indexWhere(
              (element) => element.data()['email'] == documentSnapshot.data()['email'],
            ) ==
            querySnapshot.docs.length - 1) {
          // snackBar(msg: "Please enter valid email address", context: context, isError: true);
          emailLoading.value = false;
        }
      }
    }
    emailLoading.value = false;
  }

  Future checkPass({required String pass, required String userId}) async {
    loading.value = true;
    final querySnapshot = FirebaseFirestore.instance
        .collection('main admin')
        .doc("admin id"
            "")
        .collection("user details")
        .doc(userId);

    // UserData data = UserData.fromJson(querySnapshot.get().data()!);
    if (userData.value!.pass == null) {
      if (pass.length < 6) {
        snackBar(msg: "Minimum 6 character required in password", context: context, isError: true);
      } else {
        await querySnapshot.update({"pass": pass});
        setId(userData.value!.id!);
        debugPrint("==>>>  ${userData.value!.id}");
        loading.value = false;
        return true;
      }
    } else {
      if (userData.value!.pass == pass) {
        debugPrint("done pass");
        setId(userData.value!.id!);
        debugPrint("==>>>  ${userData.value!.id}");
        loading.value = false;
        return true;
      } else {
        snackBar(msg: "Please enter valid password", context: context, isError: true);
      }
    }
    loading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    // getDocumentIds("email", "pass");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 5,
        ),
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: size.width * 0.085,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    "Welcome to Ai Sense, your complete solution "
                    "for monitoring your security cameras remotely. "
                    "With our app, you can view live video feeds,"
                    " receive real-time alerts. Let's get started!",
                    style: TextStyle(
                      color: AppColors.white70,
                      fontSize: size.width * 0.04,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  color: Color(0xFF28282e),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ValueListenableBuilder(
                      valueListenable: isEmailExist,
                      builder: (BuildContext context, bool? a, Widget? child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: size.width * 0.065,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              "Sign in with id-password provide by AI sense",
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                                color: AppColors.white70,
                              ),
                            ),
                            const SizedBox(height: 35),
                            Text(
                              "Email Id",
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 25),
                              height: 50,
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                border: Border.all(
                                    color: isEmailExist.value == null
                                        ? Colors.transparent
                                        : isEmailExist.value!
                                            ? Colors.green
                                            : Colors.red),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: TextFormField(
                                onChanged: (value) {
                                  if (emailValid(value)) {
                                    checkEmail(value);
                                  }
                                  if (value.isEmpty) {
                                    isEmailExist.value = null;
                                  }
                                },
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(color: AppColors.white),
                                decoration: const InputDecoration(
                                    isDense: true,
                                    enabledBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    hintText: "Please enter your email id",
                                    hintStyle: TextStyle(color: AppColors.white38)),
                              ),
                            ),
                            if (isEmailExist.value != null && isEmailExist.value!)
                              Text(
                                userData.value!.pass == null ? "Create Password" : "Password",
                                style: TextStyle(
                                    fontSize: size.width * 0.04, fontWeight: FontWeight.w500, color: AppColors.white),
                              ),
                            if (isEmailExist.value != null && isEmailExist.value!)
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height: 50,
                                    margin: const EdgeInsets.only(top: 10, bottom: 15),
                                    padding: EdgeInsets.only(left: size.width * 0.05, top: 8, right: size.width * 0.15),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: TextFormField(
                                      controller: pass,
                                      obscureText: isHide,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(color: AppColors.white),
                                      decoration: const InputDecoration(
                                          isDense: true,
                                          enabledBorder: InputBorder.none,
                                          border: InputBorder.none,
                                          hintText: "Please enter your password",
                                          hintStyle: TextStyle(color: AppColors.white38)),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isHide = !isHide;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                                      child: Icon(
                                        isHide ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
                                        color: AppColors.white38,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            SizedBox(
                                height: (isEmailExist.value != null && isEmailExist.value!)
                                    ? size.height * 0.15
                                    : size.height * 0.25),
                            ValueListenableBuilder(
                                valueListenable: loading,
                                builder: (BuildContext context, bool a, Widget? child) {
                                  return customBtn(
                                      color: (email.text.isEmpty || !emailValid(email.text) || pass.text.isEmpty)
                                          ? Colors.grey
                                          : AppColors.orange,
                                      size: size,
                                      name: a ? "Loading..." : "Sign In",
                                      onTap: () {
                                        if (email.text.isNotEmpty || emailValid(email.text) || pass.text.length >= 6) {
                                          checkPass(pass: pass.text, userId: userData.value!.id!).then((value) async {
                                            if (value == true) {
                                              isEmailExist.value = null;
                                              emailLoading.value = false;
                                              if (userData.value!.cat == "admin") {
                                                pushReplacement(const AdminHomeScreen(), context);
                                              } else {
                                                if (userData.value!.service) {
                                                  pushReplacement(const MainScreen(), context);
                                                } else {
                                                  disServicePopup(context, size);
                                                }
                                              }
                                            }
                                          });
                                        } else {
                                          snackBar(msg: "Please enter all fields", context: context, isError: true);
                                        }
                                      });
                                })
                          ],
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool emailValid(email) =>
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
