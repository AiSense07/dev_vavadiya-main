import 'package:ai_sense/helper/colors.dart';
import 'package:flutter/material.dart';


snackBar({required String msg, bool isError = false, required BuildContext context}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: isError ? Colors.red : Colors.green,
      content: Text(
        msg,
        style: TextStyle(color: AppColors.white),
      ),
    ),
  );
}
