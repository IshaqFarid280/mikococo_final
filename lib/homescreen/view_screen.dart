import 'dart:io';
import 'package:flutter/material.dart';
import '../services/Boxes.dart';



class ViewPictureScreen extends StatelessWidget {
  final ImageItem imageItem ;
   ViewPictureScreen({required this.imageItem});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            height: 200,
            width: 200,
            child: imageItem.isAsset ? Image.asset(imageItem.imagePath,fit: BoxFit.cover,):Image.file(File(imageItem.imagePath),fit: BoxFit.cover,),
          ),
          SizedBox(height:20,),
          Text(imageItem.title.toString()),
        ],
      ),
    );
  }
}
