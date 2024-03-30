import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mikococo/consts/strnigs.dart';
import 'package:mikococo/exercide/exercise_screen.dart';
import 'package:mikococo/homescreen/HomeScreenProvider.dart';
import 'package:mikococo/homescreen/view_screen.dart';
import 'package:mikococo/setting/motionToastConstructor.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';
import 'package:provider/provider.dart';
import '../consts/colors.dart';
import '../module/models.dart';
import '../services/Boxes.dart';
import '../widgets_common/our_button.dart';
import 'add_info_screen.dart';
import 'package:mikococo/AppLocalizations.dart';


class HomeScreen extends StatefulWidget {
  // final Function(String) ? onAdd;
  final WorkoutDay ? workoutDay;
  final isExerciseScreen ;
   HomeScreen(this.workoutDay,{this.isExerciseScreen = false});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'AddingPictures'; // Default category

  final List<String> exerciseCategories = ['AddingPictures', 'DemonPictures', 'TricepsModel', 'BicepsModel', 'ChestModel'];

  @override
  Widget build(BuildContext context) {
    var homeScreenProvider = Provider.of<HomeScreenProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: LeadingIcon(),
        title: normalText(title: appName),
      ),
      body: Consumer<HomeScreenProvider>(
        builder: (ctx, homeScreenProvider, _) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
                  normalText(title: 'Exercises',textSize:22.0),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: exerciseCategories.map((category) {
                        return Container(
                          margin:const  EdgeInsets.all(5),
                          child: ourButton(
                            onPressed: () {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                            title: category,
                            color: selectedCategory == category ? buttonColors :listTileEditColor,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
                  TextFormField(
                    enabled: true,
                    controller: homeScreenProvider.searchController,
                    onChanged: (text) {
                      homeScreenProvider.filterLists(homeScreenProvider.searchController.text.toString());
                    },
                    decoration: InputDecoration(
                      hintText: 'search',
                      hintStyle:const TextStyle(color: iconColor),
                      label: Icon(Icons.search,color: iconColor,size:30,),
                      enabledBorder: OutlineInputBorder(
                        borderSide:const BorderSide(color: iconColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:const  BorderSide(color: iconColor,width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.04,),
                  ExercisesNameListTile(exercisesCategoryName: selectedCategory),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
                  ValueListenableBuilder<Box>(
                    valueListenable: selectedCategory == 'AddingPictures' ? BoxesClass.getData().listenable() :
                    selectedCategory == 'DemonPictures' ? BoxesClass.getDemoData().listenable() :
                    selectedCategory == 'TricepsModel' ? BoxesClass.getTricepsData().listenable() :
                    selectedCategory == 'BicepsModel' ? BoxesClass.getBicepsData().listenable() :
                    BoxesClass.getChestData().listenable(),
                    builder: (context, box, _) {
                      return Column(
                        children: List.generate(
                          selectedCategory == 'AddingPictures' ? homeScreenProvider.pictures.length :
                          selectedCategory == 'DemonPictures' ? homeScreenProvider.demo.length :
                          selectedCategory == 'TricepsModel' ? homeScreenProvider.triceps.length :
                          selectedCategory == 'BicepsModel' ? homeScreenProvider.biceps.length :
                          homeScreenProvider.chest.length,
                              (index) {
                            final imageItem = selectedCategory == 'AddingPictures' ? homeScreenProvider.pictures[index] :
                            selectedCategory == 'DemonPictures' ? homeScreenProvider.demo[index] :
                            selectedCategory == 'TricepsModel' ? homeScreenProvider.triceps[index] :
                            selectedCategory == 'BicepsModel' ? homeScreenProvider.biceps[index] :
                            homeScreenProvider.chest[index];
                            // Apply filtering here
                            if (imageItem.title.toString().toLowerCase().contains(homeScreenProvider.searchController.text.toLowerCase())) {
                              String translatedTitle;
                              if (index < 6) {
                                translatedTitle = AppLocalizations.of(context)?.translate('exercise${index + 1}') ?? '';
                                print('Index: $index');
                                print('Translated Title: $translatedTitle');
                              } else {
                                translatedTitle = ''; // Set translated title to empty for index >= 6
                              }
                              print('${AppLocalizations.of(context)!.translate('exercise${index + 1}')}');
                              return Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: CustomSlider(
                                  deleteOnPressed: (context){
                                    homeScreenProvider.deleteImageItem(imageItem);
                                  },
                                  editOnPressed: (BuildContext ) {
                                    // showEditDialog(context,index);
                                    CustomMotionToast.showSuccessToast(context, 'This field will be implemented', ' in Next Milstone');
                                  },
                                  child: ListTile(
                                      contentPadding: EdgeInsets.only(left: 15,top: 5,bottom: 5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      tileColor: listTileColor,
                                      trailing: widget.isExerciseScreen ? HomeScreenAddExerciseButton(onTap: (){
                                        // add data into exercise list
                                        imageItem.isAsset ? imageItem.imagePath :imageItem.imagePath;
                                        homeScreenProvider.addExercise(imageItem.title.toString(),imageItem.imagePath,widget.workoutDay!);
                                        setState(() {
                                          print('imageURl : ${imageItem.imagePath}');
                                          print('setName : ${imageItem.title.toString()}');
                                        });
                                        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=> ExercisesScreen(widget.workoutDay!)));
                                      },) : Container(height: 5,width: 5,),
                                      onTap: (){
                                        Navigator.push(context, CupertinoPageRoute(builder: (context)=> ViewPictureScreen(imageItem:imageItem)));
                                      },
                                      title:  listTileText(
                                        title: translatedTitle.isNotEmpty ? translatedTitle : imageItem.title,
                                        textSize: 14.0,
                                      ),
                                      leading: imageItem.isAsset ? ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                              width: MediaQuery.of(context).size.width*0.15,
                                              height: MediaQuery.of(context).size.height*0.15,
                                              child: Lottie.asset(imageItem.imagePath, repeat: false,  )))
                                          : ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image(
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context).size.width*0.15,
                                            height: MediaQuery.of(context).size.height*0.15,
                                            image: FileImage(File(imageItem.imagePath ?? '')),
                                          )
                                      )

                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


