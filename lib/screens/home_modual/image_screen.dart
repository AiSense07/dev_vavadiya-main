import 'package:ai_sense/helper/colors.dart';
import 'package:ai_sense/screens/home_modual/home_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';

import '../../models/camera_model.dart';

class ImageScreen extends StatelessWidget {
  final List<Images?> imgList;
  final String camName;

  const ImageScreen({Key? key, required this.imgList, required this.camName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.primary,
        title: Text(
          "Detected Images",
          style: TextStyle(
            color: AppColors.white,
          ),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
        physics: const BouncingScrollPhysics(),
        itemCount: imgList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 20,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, indexes) {
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.width * 0.8,
                        width: size.width,
                        child: PhotoView(
                          filterQuality: FilterQuality.high,
                          gaplessPlayback: true,
                          backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                          minScale: PhotoViewComputedScale.contained,
                          maxScale: PhotoViewComputedScale.contained,
                          imageProvider: NetworkImage(imgList[indexes]!.image!),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.width * 0.33,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                      child: Image.network(imgList[indexes]!.image!),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: AppColors.primary,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            camName,
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: size.width * 0.045,
                            ),
                          ),
                          Text(
                            "Date : ${dateConvert(imgList[indexes]!.time!.toString())}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: size.width * 0.028,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

String dateConvert(String date) {
  debugPrint(date);
  List<String> dates = date.split(" ");
  List<String> time = dates[1].split(".")[0].split(":");
  List tarikh = dates[0].split("-");
  return "${time[0]}:${time[1]} AM  ${tarikh[2]}-${tarikh[1]}-${tarikh[0]}";
}
