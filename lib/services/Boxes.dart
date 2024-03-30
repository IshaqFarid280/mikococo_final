import 'package:hive/hive.dart';

import '../module/models.dart';



class BoxesClass {
  static Box<ShoulderModel> getshoulder()=> Hive.box<ShoulderModel>('shoulder') ;

  static Box<AbsModel> getabs()=> Hive.box<AbsModel>('abs') ;

  static Box<TricepsModel> getTricepsData()=> Hive.box<TricepsModel>('triceps') ;

  static Box<BicepsModel> getBicepsData()=> Hive.box<BicepsModel>('biceps') ;

  static Box<ChestModel> getChestData()=> Hive.box<ChestModel>('chest') ;

  static Box<GlutealModel> getglutealData()=> Hive.box<GlutealModel>('gluteal') ;
}



class ImageItem {
  String imagePath;
  bool isAsset;
  String   title;
  String   description;

  ImageItem(  this.imagePath,  this.title, this.description ,{this.isAsset = false,});
}