import 'package:flutter/material.dart';

import '../helper/colors.dart';
import '../helper/navigations.dart';

class ConfirmationPopupBtn extends StatelessWidget {
  final Size size;
  final String title;
  final Function onTap;
  final Color textColor;
  final Color btnColor;

  const ConfirmationPopupBtn({
    Key? key,
    required this.size,
    required this.title,
    required this.onTap,
    required this.textColor,
    required this.btnColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          height: 45,
          decoration: BoxDecoration(
              color: btnColor,
              borderRadius: title == "No" || title == "Exit"
                  ? const BorderRadius.only(bottomLeft: Radius.circular(10))
                  : const BorderRadius.only(bottomRight: Radius.circular(10))),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(color: textColor,fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

popup({
  required Size size,
  required BuildContext context,
  bool isBack = false,
  required String title,
  required Function onYesTap,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actionsPadding: EdgeInsets.zero,
        content: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: size.width * 0.05,color: AppColors.white),
        ),
        actions: [
          Container(color: Colors.white70, height: 1),
          Row(
            children: [
              ConfirmationPopupBtn(
                  size: size,
                  title: "No",
                  onTap: () {
                    pop(context);
                  },
                  textColor: isBack ? Colors.black : Colors.white,
                  btnColor: isBack ? Colors.white : AppColors.white38),
              Container(color: Colors.white70, height: 45,width: 1),
              ConfirmationPopupBtn(
                  size: size,
                  title: "Yes",
                  onTap: () {
                    onYesTap();
                    pop(context);
                  },
                  textColor: isBack ? Colors.white : Colors.white,
                  btnColor: isBack ? AppColors.white70 : AppColors.primary),
            ],
          ),
        ],
      );
    },
  );
}
