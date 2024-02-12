import 'package:hive/hive.dart';

import '../module/models.dart';



class BoxesClass {
  static Box<AddingPictures> getData()=> Hive.box<AddingPictures>('Pictures') ;

  static Box<DemonPictures> getDemoData()=> Hive.box<DemonPictures>('Demo') ;

  static Box<TricepsModel> getTricepsData()=> Hive.box<TricepsModel>('triceps') ;

  static Box<BicepsModel> getBicepsData()=> Hive.box<BicepsModel>('biceps') ;

  static Box<ChestModel> getChestData()=> Hive.box<ChestModel>('chest') ;
}



class ImageItem {
  String imagePath;
  bool isAsset;
  String   title;
  String   description;

  ImageItem(  this.imagePath,  this.title, this.description ,{this.isAsset = false,});
}