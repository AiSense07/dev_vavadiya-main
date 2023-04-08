import 'package:ai_sense/models/camera_model.dart';
import 'package:ai_sense/models/user_model.dart';
import 'package:flutter/cupertino.dart';

ValueNotifier<UserData?> userData = ValueNotifier(null);

ValueNotifier<String> userId = ValueNotifier("");
ValueNotifier<String> mobileNumber = ValueNotifier("");

ValueNotifier<bool> loading = ValueNotifier(false);

ValueNotifier<bool> serviceLoading = ValueNotifier(false);

ValueNotifier<bool> emailLoading = ValueNotifier(false);

ValueNotifier<bool?> isEmailExist = ValueNotifier(null);

ValueNotifier<List<CameraModel>> cameraList = ValueNotifier([CameraModel()]);

ValueNotifier<List<UserData>> userList = ValueNotifier([UserData()]);
