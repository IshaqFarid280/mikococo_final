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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () { Navigator.of(context).pop();},
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context)=>AddPictureScreen(
            pictures: homeScreenProvider.pictures,
            filteredPictures: homeScreenProvider.filteredPictures,
            demo: homeScreenProvider.demo,
            filteredDemo: homeScreenProvider.filteredDemo,
          )));
          // _showDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<HomeScreenProvider>(
        builder: (ctx, homeScreenProvider, _){
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: homeScreenProvider.searchController,
                        onChanged: (text) {
                          homeScreenProvider.filterLists(homeScreenProvider.searchController.text.toString());
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30,),
                      Text('Abs'),
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
                      Text('Chest'),
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
