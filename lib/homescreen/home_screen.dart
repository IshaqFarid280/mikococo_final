import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mikococo/exercide/exercise_screen.dart';
import 'package:mikococo/homescreen/HomeScreenProvider.dart';
import 'package:mikococo/homescreen/view_screen.dart';
import 'package:provider/provider.dart';
import '../module/models.dart';
import '../services/Boxes.dart';
import 'add_info_screen.dart';


class HomeScreen extends StatefulWidget {
  // final Function(String) ? onAdd;
  final WorkoutDay ? workoutDay;
   HomeScreen(this.workoutDay);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // TextEditingController titleController = TextEditingController();
  // TextEditingController searchController = TextEditingController();
  // TextEditingController descriptionController = TextEditingController();
  // String? pickedImagePath;
  // String selectedList = 'pictures';
  //
  // Future<String?> pickImageFromGallery() async {
  //   final imagePicker = ImagePicker();
  //   final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     return pickedFile.path;
  //   }
  //   return null;
  // }
  //
  //
  // void addExercise(String name,String imagePath,WorkoutDay workoutDay) {
  //   final exercise = Exercise(name,imagePath,null);
  //   Hive.box<Exercise>('ExercisesBox').add(exercise).then((exerciseKey) {
  //     workoutDay.exercises.add(exerciseKey);
  //     workoutDay.save();
  //   });
  // }
  //
  // void addExerciseToWorkout(Exercise exercise) {
  //   setState(() {
  //     widget.workoutDay!.exercises.add(exercise.key);
  //     widget.workoutDay!.save();
  //   });
  // }
  //
  // List<ImageItem> pictures = [];
  // List<ImageItem> demo = [];
  // List<ImageItem> filteredPictures = [];
  // List<ImageItem> filteredDemo = [];
  //
  //
  // void filterLists(String searchText) {
  //   setState(() {
  //     filteredPictures = pictures
  //         .where((image) =>
  //         image.title.toString().toLowerCase().contains(searchText.toLowerCase()))
  //         .toList();
  //     filteredDemo = demo
  //         .where((image) =>
  //         image.title.toString().toLowerCase().contains(searchText.toLowerCase()))
  //         .toList();
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   // Load user-added images from Hive and append them to the pictures list
  //   final box = BoxesClass.getData();
  //   final pictureListUserImages = box.values.map((value) =>
  //       ImageItem(value.image.toString(), value.title.toString(), isAsset: false)).toList();
  //   // Load user-added images from Hive and append them to the pictures list
  //   final demoBox = BoxesClass.getDemoData();
  //   final demoListUserImages = demoBox.values.map((value) =>
  //       ImageItem(value.image.toString(), value.title.toString(), isAsset: false)).toList();
  //   // Initialize filteredPictures with the combined list of assets and Hive data
  //   homeScreenProvider.pictures.addAll(pictureListUserImages);
  //   homeScreenProvider.pictures.addAll([
  //     ImageItem('assets/images/demon.gif', 'Goku', isAsset: true),
  //     ImageItem('assets/images/demon1.gif', 'Vegeta', isAsset: true),
  //     ImageItem('assets/images/demon2.gif', 'Rengoku', isAsset: true),
  //     ImageItem('assets/images/goku.gif', 'Tangero', isAsset: true),
  //     ImageItem('assets/images/vegeta.gif', 'Tomia', isAsset: true),
  //   ]);
  //   homeScreenProvider.demo.addAll(demoListUserImages);
  //   homeScreenProvider.demo.addAll([
  //     ImageItem('assets/images/demon.gif', 'Goku', isAsset: true),
  //     ImageItem('assets/images/demon1.gif', 'Vegeta', isAsset: true),
  //     ImageItem('assets/images/demon2.gif', 'Rengoku', isAsset: true),
  //     ImageItem('assets/images/goku.gif', 'Tangero', isAsset: true),
  //     ImageItem('assets/images/vegeta.gif', 'Tomia', isAsset: true),
  //   ]);
  //   // Initialize filteredPictures with the combined list
  //   homeScreenProvider.filteredPictures = List.from(homeScreenProvider.pictures);
  //   // Initialize filteredDemo with the demo list
  //   homeScreenProvider.filteredDemo = List.from(homeScreenProvider.demo);
  // }

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
                                    trailing: IconButton(onPressed: ()  {
                                      // add data into exercise list

                                      imageItem.isAsset ? imageItem.imagePath :imageItem.imagePath;
                                      homeScreenProvider.addExercise(imageItem.title.toString(),imageItem.imagePath,widget.workoutDay!);
                                      setState(() {
                                        print('imageURl : ${imageItem.imagePath}');
                                        print('setName : ${imageItem.title.toString()}');
                                      });
                                      Navigator.pop(context);
                                      Navigator.push(context, CupertinoPageRoute(builder: (context)=> ExercisesScreen(widget.workoutDay!)));
                                    }, icon: Icon(Icons.add)),
                                    onTap: (){
                                      Navigator.push(context, CupertinoPageRoute(builder: (context)=> ViewPictureScreen(imageItem:imageItem)));
                                    },
                                    title: Text(imageItem.title.toString()),
                                    tileColor: Colors.blueGrey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    leading: CircleAvatar(
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
                                      trailing: IconButton(onPressed: (){
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
                                        Navigator.push(context, CupertinoPageRoute(builder: (context)=> ExercisesScreen(widget.workoutDay!)));
                                      }, icon: Icon(Icons.add)),
                                      onTap: (){
                                        Navigator.push(context, CupertinoPageRoute(builder: (context)=> ViewPictureScreen(imageItem:imageItem)));
                                      },
                                      title: Text(imageItem.title.toString()),
                                      tileColor: Colors.blueGrey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      leading: CircleAvatar(
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
