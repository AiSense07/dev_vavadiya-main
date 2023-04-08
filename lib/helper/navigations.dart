import 'package:flutter/material.dart';

push(Widget screen, BuildContext context) {
  return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ));
}

pushReplacement(Widget screen, BuildContext context) {
  return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ));
}

pop(BuildContext context) {
  return Navigator.pop(context);
}
