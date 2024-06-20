import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(
    String message, {
      Color textColor = Colors.white,
      Color backgroundColor = Colors.black,
    }) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    textColor: textColor,
    fontSize: 16.0,
    backgroundColor: backgroundColor,
  );
}