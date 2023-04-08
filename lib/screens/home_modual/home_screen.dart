import 'dart:convert';

import 'package:ai_sense/controller/notifier.dart';
import 'package:ai_sense/helper/colors.dart';
import 'package:ai_sense/helper/navigations.dart';
import 'package:ai_sense/helper/widgets.dart';
import 'package:ai_sense/screens/home_modual/camera_screen.dart';
import 'package:ai_sense/screens/home_modual/image_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/camera_model.dart';
import 'add_cam_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// List<String> dummy = [
//   "Cam 1",
//   "Cam 2",
//   "Cam 3",
//   "Cam 4",
//   "Cam 5",
//   "Cam 6",
// ];

// Map<String, dynamic> data = {
//   "images": [
//     {
//       "image": "https://media.istockphoto.com/id/618066222/photo/camera-capturing"
//           "-a-forest.jpg?s=612x612&w=is&k=20&c=yWpOstN4LreKDQgB1CTD5mkbY41vi6h5tp6MNPN2sEo=",
//       "time": "2021-01-01T12:00:00.000Z"
//     },
//     {
//       "image": "https://media.istockphoto.com/id/482112104/photo/security-cctv-camera-in-office-b"
//           "uilding.jpg?s=612x612&w=0&k=20&c=vT86olucO-hgeIZ1zV1Lx97X_54h7dzx2yJ8LRSo7IM=",
//       "time": "2021-01-01T12:00:00.000Z"
//     },
//     {
//       "image": "https://images.unsplash.com/photo-1589935447067-55310944"
//           "15d1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8c2VjdXJpdHklMjBjYW1lcmF"
//           "8ZW58MHx8MHx8&w=1000&q=80",
//       "time": "2021-01-01T12:00:00.000Z"
//     },
//     {
//       "image": "https://media.istockphoto.com/id/482112104/photo/security-cctv-camera-in-office-b"
//           "uilding.jpg?s=612x612&w=0&k=20&c=vT86olucO-hgeIZ1zV1Lx97X_54h7dzx2yJ8LRSo7IM=",
//       "time": "2021-01-01T12:00:00.000Z"
//     },
//     {
//       "image": "https://encrypted-tbn0.gstatic.com/images?q=t"
//           "bn:ANd9GcTyFFZVeAZrpSspAPwjHg5Y2M8f7S-nVakIYw&usqp=CAU",
//       "time": "2021-01-01T12:00:00.000Z"
//     },
//   ],
//   "camera_details": {
//     "start_time": "2021-01-01T12:00:00.000Z",
//     "streaming": true,
//     "calls": true,
//     "name": "cam1",
//     "end_time": "2021-01-01T12:00:00.000Z",
//     "face_detection": true,
//   }
// };

Map<String, dynamic> user = {
  "cam setting": {
    "calls": true,
    "start_time": "2021-01-01T12:00:00.000Z",
    "end_time": "2021-01-01T12:00:00.000Z",
  },
  "name": "yash savani",
  "email": "b@gmail.com",
  "pass": "159753",
  "id": "user id 2"
};

class _HomeScreenState extends State<HomeScreen> {
  bool isLoad = false;

  String selectedTab = "Live Cameras";

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  getUsers() async {
/*    // Get a reference to the document you want to add the collection to
    DocumentReference docRef =  FirebaseFirestore.instance.collection('main admin').doc('admin id');

// Add a new collection to the document
    CollectionReference newCollectionRef = docRef.collection('user id 3');

// Add a document to the new collection
    newCollectionRef.add({
      'field1': 'value1',
      'field2': 'value2',
    });*/

    // await firestore.collection('main admin').doc('admin id').collection("user details").doc("user id 1").update(user);
    final querySnapshot =
        await FirebaseFirestore.instance.collection('main admin').doc("admin id").collection(userId.value).get();
    cameraList.value = [];
    for (var data in querySnapshot.docs) {
      CameraModel cameraModel = CameraModel.fromJson(data.data());
      cameraList.value.add(cameraModel);
    }
    // for(var data in querySnapshot)
    // DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore.collection('admin').doc('user 1').get();
    // DocumentReference snapshots = firestore.collection('main admin').doc('admin id 2').collection("user id 2").doc("cam 1 id");
    // await firestore.collection('main admin').doc('admin id').collection("user id 1").doc("cam 3 id").set(data);
    // List usernames = snapshota.docs.map((doc) => doc.data()).toList();
    // Map<String, dynamic>? username = snapshot.data();
    // await snapshots.update(data);
    // debugPrint("===>>>  ${jsonEncode(usernames[0])}");
    // return usernames;
  }

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        setState(() {
          isLoad = true;
        });
        await getUsers();
        setState(() {
          isLoad = false;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("==>> user name ${userData.value!.toJson()}");
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20,
          bottom: MediaQuery.of(context).padding.bottom + 15,
          right: size.width * 0.05,
          left: size.width * 0.05,
        ),
        child: ValueListenableBuilder(
            valueListenable: cameraList,
            builder: (BuildContext context, List<CameraModel> camera, Widget? child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hello, ${userData.value!.name}",
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: size.width * 0.065,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      tabs(size: size, title: "Live Cameras"),
                      tabs(size: size, title: "Detected Images"),
                    ],
                  ),
                  Text(
                    "${camera.length} Cameras",
                    style: TextStyle(
                      color: AppColors.white60,
                      fontSize: size.width * 0.048,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (selectedTab == "Live Cameras")
                    isLoad
                        ? Container(
                            alignment: Alignment.center,
                            height: size.height * 0.5,
                            width: size.width,
                            child: Image.asset("assets/loading.gif", height: 130),
                          )
                        : GridView.builder(
                            itemCount: camera.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 13, bottom: 25),
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                            ),
                            itemBuilder: (context, index) {
                              return camera[index].images == null || camera[index].images!.isEmpty
                                  ? Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.black,
                                          border: Border.all(color: AppColors.white, width: 1.5),
                                          image: const DecorationImage(image: AssetImage("assets/giphy.gif"))),
                                    )
                                  : Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            push(CameraScreen(camList: camera, index: index), context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color: AppColors.white,
                                              image: DecorationImage(
                                                image: NetworkImage(camera[index].images![0]!.image!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                          decoration: BoxDecoration(
                                              color: AppColors.white60, borderRadius: BorderRadius.circular(5)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              CircleAvatar(backgroundColor: Colors.red, radius: 3),
                                              SizedBox(width: 5),
                                              Text(
                                                "Live",
                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                            decoration: BoxDecoration(
                                                color: AppColors.white60, borderRadius: BorderRadius.circular(5)),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  camera[index].cameraDetails!.name!,
                                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                            },
                          )
                  else
                    GridView.builder(
                      itemCount: camera.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 13, bottom: 25),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemBuilder: (context, index) {
                        return imgGrid(
                            size: size, imgList: camera[index].images!, camName: camera[index].cameraDetails!.name!);
                      },
                    ),
                  if (selectedTab == "Live Cameras" && !isLoad)
                    customBtn(
                      size: size,
                      name: "Add Camera",
                      onTap: () {
                        push(AddCamSheet(), context);
                        // showModalBottomSheet(
                        //   // isScrollControlled: true,
                        //
                        //   backgroundColor: AppColors.primary,
                        //   shape: const RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                        //   ),
                        //   context: context,
                        //   builder: (context) {
                        //     return AddCamSheet();
                        //   },
                        // );
                      },
                    )
                ],
              );
            }),
      ),
    );
  }

  Widget tabs({required Size size, required String title}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = title;
        });
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: 50,
        decoration: BoxDecoration(
          color: selectedTab == title ? AppColors.primary : Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: size.width * 0.045,
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget imgGrid({required Size size, required List<Images?>? imgList, required String camName}) {
    return imgList!.isEmpty || imgList == null
        ? Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black,
                border: Border.all(color: AppColors.white, width: 1.5),
                image: const DecorationImage(image: AssetImage("assets/giphy.gif"))),
          )
        : GestureDetector(
            onTap: () {
              push(ImageScreen(imgList: imgList, camName: camName), context);
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black,
                    border: Border.all(color: AppColors.white, width: 1.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      height: size.width * 0.5,
                      child: imgList.length == 1
                          ? networkImg(
                              url: imgList[0]!.image!,
                              size: size,
                              index: 0,
                            )
                          : imgList.length == 2
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    networkImg(
                                      url: imgList[0]!.image!,
                                      size: size,
                                      index: 2,
                                    ),
                                    networkImg(
                                      url: imgList[1]!.image!,
                                      size: size,
                                      index: 2,
                                    ),
                                  ],
                                )
                              : imgList.length == 3
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            networkImg(
                                              url: imgList[0]!.image!,
                                              size: size,
                                              index: 1,
                                            ),
                                            networkImg(
                                              url: imgList[1]!.image!,
                                              size: size,
                                              index: 1,
                                            ),
                                          ],
                                        ),
                                        networkImg(
                                          url: imgList[2]!.image!,
                                          size: size,
                                          index: 2,
                                        ),
                                      ],
                                    )
                                  : imgList.length == 4
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                networkImg(
                                                  url: imgList[0]!.image!,
                                                  size: size,
                                                  index: 1,
                                                ),
                                                networkImg(
                                                  url: imgList[1]!.image!,
                                                  size: size,
                                                  index: 1,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                networkImg(
                                                  url: imgList[2]!.image!,
                                                  size: size,
                                                  index: 1,
                                                ),
                                                networkImg(
                                                  url: imgList[3]!.image!,
                                                  size: size,
                                                  index: 1,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Image.network(
                                                  imgList[0]!.image!,
                                                  fit: BoxFit.cover,
                                                  height: size.width / 4.8,
                                                  width: size.width / 4.8,
                                                ),
                                                Image.network(
                                                  imgList[1]!.image!,
                                                  fit: BoxFit.cover,
                                                  height: size.width / 4.8,
                                                  width: size.width / 4.8,
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Image.network(
                                                  imgList[2]!.image!,
                                                  fit: BoxFit.cover,
                                                  height: size.width / 4.8,
                                                  width: size.width / 4.8,
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black12,
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(imgList[3]!.image!),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: size.width / 4.8,
                                                    width: size.width / 4.8,
                                                    color: Colors.black38,
                                                    child: Text(
                                                      "+ ${imgList.length - 3}",
                                                      style: TextStyle(
                                                        color: AppColors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: size.width * 0.07,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                    ),
                  ),
                ),
                Positioned(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.white60, borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          camName,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

String img = "http://hackread.com/wp-content/uploads/2014/11/see-how-a"
    "-creepy-website-is-streaming-from-73000-private-security-cameras-6.jpg";
