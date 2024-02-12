import 'package:flutter/material.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/widgets_common/our_button.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';
import 'package:provider/provider.dart';

import 'export_provider.dart';




class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: largeText(title: 'CSV Export'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height:MediaQuery.sizeOf(context).height * 0.1,),
            normalText(title: 'Export Data directly into your phone storage',textSize:14.0),
            SizedBox(height:MediaQuery.sizeOf(context).height * 0.01,),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.43,
              child: ourButton(
                title: 'Export',
                onPressed: (){
                  Provider.of<ExportProvider>(context, listen: false).exportData(context);
                }
              ),
            ),
            SizedBox(height:MediaQuery.sizeOf(context).height * 0.05,),
            Container(
              height:2,
              width: MediaQuery.sizeOf(context).width * 0.95,
              color: buttonColors,

            ),
            SizedBox(height:MediaQuery.sizeOf(context).height * 0.05,),
            normalText(title: 'Share Exported Data directly to others',textSize:14.0),
            SizedBox(height:MediaQuery.sizeOf(context).height * 0.01,),
            ourButton(
              title: 'Share Exported Data',
              onPressed: (){
                Provider.of<ExportProvider>(context, listen: false).shareExportedFile();
              }
            ),
          ],
        ),
      ),
    );
  }
}
