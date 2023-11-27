import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mikococo/exercide/exercise_screen.dart';
import 'package:mikococo/homescreen/HomeScreenProvider.dart';
import 'package:mikococo/homescreen/view_screen.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';
import 'package:provider/provider.dart';
import '../consts/colors.dart';
import '../module/models.dart';
import '../services/Boxes.dart';
import '../widgets_common/our_button.dart';
import 'add_info_screen.dart';


class HomeScreen extends StatefulWidget {
  // final Function(String) ? onAdd;
  final WorkoutDay ? workoutDay;
  final isExerciseScreen ;
   HomeScreen(this.workoutDay,{this.isExerciseScreen = false});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    var homeScreenProvider = Provider.of<HomeScreenProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: LeadingIcon(),

        title: normalText(title: 'Globalfit'),
        actions: [
          AddThingsIcon(
            svgAsset: 'assets/svg/plusicon.svg',svgColor: iconColor,
              onTap: (){
            Navigator.push(context, CupertinoPageRoute(builder: (context)=>AddPictureScreen(
              pictures: homeScreenProvider.pictures,
              filteredPictures: homeScreenProvider.filteredPictures,
              demo: homeScreenProvider.demo,
              filteredDemo: homeScreenProvider.filteredDemo,
            )));
          }),
        ],
      ),
      body: Consumer<HomeScreenProvider>(
        builder: (ctx, homeScreenProvider, _){
          return SingleChildScrollView(
            physics:const  BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
                      normalText(title: 'Exercises',textSize:22.0),
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
                      ExercisesNameListTile(exercisesCategoryName:'Abs',),
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
                      ValueListenableBuilder<Box<AddingPictures>>(
                        valueListenable: BoxesClass.getData().listenable(),
                        builder: (context, box, _) {
                          return Column(
                            children:List.generate(
                              homeScreenProvider.pictures.length, (index){
                              final imageItem = homeScreenProvider.pictures[index]; // Use pictures to get the items
                              // Apply filtering here
                              if (imageItem.title.toString().toLowerCase().contains(homeScreenProvider.searchController.text.toLowerCase())) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.only(left: 15,top: 5,bottom: 5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    tileColor: listTileColor,
                                    trailing:widget.isExerciseScreen ?  IconButton(onPressed: ()  {
                                      // add data into exercise list
                                      imageItem.isAsset ? imageItem.imagePath :imageItem.imagePath;
                                      homeScreenProvider.addExercise(imageItem.title.toString(),imageItem.imagePath,widget.workoutDay!);
                                      setState(() {
                                        print('imageURl : ${imageItem.imagePath}');
                                        print('setName : ${imageItem.title.toString()}');
                                      });
                                      Navigator.pop(context);
                                      Navigator.push(context, CupertinoPageRoute(builder: (context)=> ExercisesScreen(widget.workoutDay!)));
                                    }, icon: Icon(Icons.add)) : Container(height: 5,width: 5,),
                                    onTap: (){
                                      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=> ViewPictureScreen(imageItem:imageItem)));
                                    },
                                    title: listTileText(title:imageItem.title.toString().toUpperCase()),
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundImage: imageItem.isAsset
                                          ? AssetImage(imageItem.imagePath)
                                          : FileImage(File(imageItem.imagePath)) as ImageProvider,
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },),
                          );
                        },
                      ),
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
                      ExercisesNameListTile(exercisesCategoryName:'Legs',),
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
                      ValueListenableBuilder<Box<DemonPictures>>(
                          valueListenable: BoxesClass.getDemoData().listenable(),
                          builder: (context,box,_) {
                            return Column(
                              children: List.generate(
                                homeScreenProvider.demo.length, (index) {
                                final imageItem = homeScreenProvider.demo[index];
                                if (imageItem.title.toString().toLowerCase().contains(homeScreenProvider.searchController.text.toLowerCase())) {
                                  // var data = box.values.toList().cast<AddingPictures>();
                                  return Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.only(left: 15,top: 5,bottom: 5),
                                      trailing:widget.isExerciseScreen ?  IconButton(onPressed: (){
                                        // add data into exercise list

                                        imageItem.isAsset  ?  imageItem.imagePath :imageItem.imagePath;
                                        homeScreenProvider.addExercise(imageItem.title.toString(),imageItem.imagePath,widget.workoutDay!);
                                        setState(() {
                                          if(imageItem.imagePath.contains('assets/images')){
                                            print('imageURlAssets: ${imageItem.imagePath}');
                                            print('imageURlAssets: ${imageItem.title}');
                                          }else{
                                            print('imageURlFile: ${imageItem.imagePath}');
                                          }
                                        });
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=> ExercisesScreen(widget.workoutDay!)));
                                      }, icon: Icon(Icons.add)) : Container(height: 5,width: 5,),
                                      onTap: (){
                                        Navigator.push(context, CupertinoPageRoute(builder: (context)=> ViewPictureScreen(imageItem:imageItem)));
                                      },
                                      title: listTileText(title :imageItem.title.toString().toUpperCase()),
                                      tileColor: listTileColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      leading: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: imageItem.isAsset
                                            ? AssetImage(imageItem.imagePath)
                                            : FileImage(File(imageItem.imagePath)) as ImageProvider,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                              ),
                            );
                          }
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
