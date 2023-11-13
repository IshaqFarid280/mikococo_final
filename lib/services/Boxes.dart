import 'package:hive/hive.dart';

import '../module/models.dart';



class BoxesClass {
  static Box<AddingPictures> getData()=> Hive.box<AddingPictures>('Pictures') ;

  static Box<DemonPictures> getDemoData()=> Hive.box<DemonPictures>('Demo') ;
}



class ImageItem {
  String imagePath;
  bool isAsset;
  String  ? title;

  ImageItem(this.imagePath,  this.title ,{this.isAsset = false,});
}