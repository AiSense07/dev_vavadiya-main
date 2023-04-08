import 'package:ai_sense/helper/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Widget customBtn({
  required Size size,
  required String name,
  Color? color,
  required Function onTap,
}) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Container(
      alignment: Alignment.center,
      height: 50,
      decoration: BoxDecoration(
        color: color ?? AppColors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: size.width * 0.05,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

Widget networkImg({required Size size, required String url, required int index}) {
  return Image.network(
    url,
    fit: BoxFit.cover,
    height: index == 0 ? null : size.width / 4.8,
    width: index == 0
        ? null
        : index == 1
            ? size.width / 4.8
            : size.width / 2.2,
  );
}

class CustomTextField extends StatefulWidget {
  final String hint;
  final String title;
  final TextEditingController controller;
  final Size size;
  final bool isHide;
  final bool isPass;
  final Function(String value)? onChange;

  const CustomTextField({
    Key? key,
    required this.hint,
    required this.title,
    required this.controller,
    required this.size,
    this.isHide = false,
    this.isPass = false, this.onChange,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isHide = false;

  @override
  void initState() {
    // TODO: implement initState
    isHide = widget.isHide;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(fontSize: widget.size.width * 0.04, fontWeight: FontWeight.w500, color: AppColors.white),
        ),
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              height: 50,
              margin: const EdgeInsets.only(top: 8, bottom: 30, left: 8),
              padding: EdgeInsets.only(left: widget.size.width * 0.05, top: 8, right: widget.size.width * 0.15),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                onChanged: (value){
                  widget.onChange!(value);
                },
                style: TextStyle(color: AppColors.white),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  isDense: true,
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText: widget.hint,
                  hintStyle: TextStyle(color: AppColors.white38),
                ),
              ),
            ),
            if (widget.isPass)
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
      ],
    );
  }
}
