
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Widget ourButton({ onpressed, color, textColor, String? title}) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(color),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(12)),
    ),
    onPressed: onpressed,
    child: Text(
      title!,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
