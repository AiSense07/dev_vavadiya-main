import 'dart:convert';

import 'package:ai_sense/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/camera_model.dart';
import 'notifier.dart';

Future<SharedPreferences> _share() async {
  return await SharedPreferences.getInstance();
}

void clear() async {
  SharedPreferences preferences = await _share();
  userData.value = null;
  cameraList.value = [CameraModel()];
  userId.value = '';
  isEmailExist.value = null;
  await preferences.clear();
}

void setId(String id) async {
  SharedPreferences share = await _share();
  userId.value = id;
  debugPrint("==>> setId $id");
  await share.setString("Id", id);
}

Future<String> getId() async {
  SharedPreferences share = await _share();
  String? id = share.getString("Id");
  userId.value = id ?? "";
  debugPrint("==>> getId $id");
  return id ?? "";
}

void setUserData(UserData data) async {
  SharedPreferences share = await _share();
  userData.value = data;
  debugPrint("==>>setUserData ${jsonEncode(data.toJson())} ");
  await share.setString("userData", jsonEncode(data.toJson()));
}

Future<UserData?> getUserData() async {
  SharedPreferences share = await _share();
  String? userDatas = share.getString("userData");
  debugPrint("==>> getUserData = $userDatas");
  userData.value = userDatas == null ? null : UserData.fromJson(jsonDecode(userDatas));
  return userDatas == null ? null : UserData.fromJson(jsonDecode(userDatas));
}

void setMobile(String mobile) async {
  SharedPreferences share = await _share();
  mobileNumber.value = mobile;
  debugPrint("==>> set mobile $mobile");
  await share.setString("mobile", mobile);
}

Future<String> getMobile() async {
  SharedPreferences share = await _share();
  String? mobile = share.getString("mobile");
  mobileNumber.value = mobile ?? "";
  debugPrint("==>> get mobile $mobile");
  return mobile ?? "";
}
