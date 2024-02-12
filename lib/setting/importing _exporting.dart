import 'package:flutter/material.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/widgets_common/our_button.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';
import 'package:provider/provider.dart';
import 'hive_import_export.dart';



class DataExport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hiveProvider = Provider.of<HiveProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: normalText(title: 'Export DataBase'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.1,),
            normalText(title: 'Export  your DataBase and share it to others',textSize:14.0),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.02,),
            ourButton(
              title:'Export Data',
              onPressed: () async {
                String filePath = await hiveProvider.exportData(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Data exported and saved to $filePath'),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}


class DataImport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hiveProvider = Provider.of<HiveProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: normalText(title: 'Import DataBase'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.1,),
            normalText(title: 'Import DataBase to the your data base',textSize:14.0),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.03,),
            ourButton(
              title: 'Import Data',
              onPressed: () async {
                await hiveProvider.importDataFromFile();
              },
            ),
          ],
        ),
      ),
    );
  }
}