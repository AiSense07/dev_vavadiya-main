import 'package:ai_sense/helper/colors.dart';
import 'package:ai_sense/helper/navigations.dart';
import 'package:ai_sense/screens/home_modual/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import '../../models/camera_model.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraModel> camList;
  final int index;

  const CameraScreen({Key? key, required this.camList, required this.index}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String? valueChoose;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    valueChoose = widget.camList[widget.index].cameraDetails!.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        return Future(() => true);
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                height: size.height,
                child: Stack(
                  children: [
                    Image.network(
                      widget.camList[widget.index].images![0]!.image!,
                      fit: BoxFit.contain,
                      height: size.height,
                      // width: size.height * 0.7,
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.white60, borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(backgroundColor: Colors.red, radius: 3),
                          const SizedBox(width: 5),
                          Text(
                            "Live",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown,
                    ]);
                    pop(context);
                  },
                  child: const CircleAvatar(
                    backgroundColor: AppColors.primary,
                    radius: 25,
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
              Positioned(right: 10, top: 25, child: dropDown(height: 50, size: size)),
            ],
          ),
        ),
      ),
    );
  }

  Widget dropDown({required double height, String? hintText, required Size size}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 40,
            width: 95,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 1, color: AppColors.white),
              color: AppColors.white38,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                borderRadius: BorderRadius.circular(10),
                dropdownColor: const Color(0xff3c3c44),
                hint: const Text("choose"),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.white,
                ),
                iconSize: 20,
                isExpanded: true,
                value: valueChoose,
                onChanged: (value) async {
                  setState(() {
                    valueChoose = value.toString();
                  });
                },
                items: widget.camList.map((value) {
                  return DropdownMenuItem<String>(
                    value: value.cameraDetails!.name,
                    child: Text(
                      value.cameraDetails!.name!,
                      style: TextStyle(color: AppColors.white),
                    ),
                  );
                }).toList(),
              ),
            )),
      ],
    );
  }
}
