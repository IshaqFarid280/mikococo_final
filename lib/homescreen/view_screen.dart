import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/consts/strnigs.dart';
import 'package:mikococo/widgets_common/our_button.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';
import '../services/Boxes.dart';



class ViewPictureScreen extends StatelessWidget {
  final ImageItem imageItem ;
   ViewPictureScreen({required this.imageItem});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: LeadingIcon(),
        title: normalText(title: appName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
            Container(
              height: MediaQuery.sizeOf(context).height * 0.25,
              width: MediaQuery.sizeOf(context).width * 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: listTileLeadingColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:const  EdgeInsets.only(left: 10,top: 10),
                      child: largeText(title:imageItem.title,color: goldenColor,textSize:22.0)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(right:8),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: imageItem.isAsset ? AssetImage(imageItem.imagePath.toString(),):FileImage(File(imageItem.imagePath)) as ImageProvider,fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: MediaQuery.sizeOf(context).height * 0.23,
                      width: MediaQuery.sizeOf(context).width * 0.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.05,),
            largeText(title: 'Description :'),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.02,),
            smallText(title: '. kk kk kkk kkk kkk',textSize:14.0),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
            smallText(title: '. kk kk kkk kkk kkk',textSize:14.0),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
            smallText(title: '. kk kk kkk kkk kkk',textSize:14.0),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
            smallText(title: '. kk kk kkk kkk kkk',textSize:14.0),
          ],
        ),
      ),
    );
  }
}
