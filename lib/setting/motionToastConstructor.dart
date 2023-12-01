import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class CustomMotionToast {
  static void showSuccessToast(BuildContext context, String text, String descritpion) {
    MotionToast.success(
      iconType: IconType.materialDesign,
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.8,
      title: Text(text, style: TextStyle(fontSize: 12)),
      borderRadius: 5,
      dismissable: true,
      animationDuration: Duration(seconds: 3),
      description: Text(descritpion, style: TextStyle(fontSize: 12)),
    ).show(context);
  }
}