import 'dart:convert';
import 'dart:io';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mikococo/consts/strnigs.dart';
import 'package:mikococo/exercide/ExerciseScreenProvider.dart';
import 'package:mikococo/exercide/edit_exercise.dart';
import 'package:mikococo/exercide/exercise_screen.dart';
import 'package:mikococo/homescreen/HomeScreenProvider.dart';
import 'package:mikococo/homescreen/view_screen.dart';
import 'package:mikococo/l10n/app_localization.dart';
import 'package:mikococo/setting/motionToastConstructor.dart';
import 'package:mikococo/widgets_common/category_exercise_tab.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';
import 'package:provider/provider.dart';
import '../consts/colors.dart';
import '../l10n/languageProvider.dart';
import '../module/models.dart';
import '../services/Boxes.dart';
import '../widgets_common/our_button.dart';
import 'add_info_screen.dart';
import 'package:mikococo/l10n/AppLocalizations.dart';

class HomeScreen extends StatefulWidget {
  // final Function(String) ? onAdd;
  final WorkoutDay? workoutDay;
  final isExerciseScreen;

  HomeScreen(this.workoutDay, {this.isExerciseScreen = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'Chest'; // Default category
  List<String> exerciseCategories = [];

  @override
  void initState() {
    super.initState();
    loadCategories('en'); // Default language is English
  }

  Future<void> loadCategories(String languageCode) async {
    String jsonString = await rootBundle.loadString('assets/i18n/$languageCode.json');
    Map<String, dynamic> languageMap = json.decode(jsonString);
    setState(() {
      exerciseCategories = List<String>.from(languageMap['exercise_categories']);
    });
  }

  // final List<String> exerciseCategories = [
  //   'Chest',
  //   'Biceps',
  //   'Triceps',
  //   'Abs',
  //   'Gluteal',
  //   'Shoulder',
  //   // 'Butt'
  // ];

  final List<String> exerciseCategoriesimages = [
    'assets/json/ab coaster abdominaux.json',
    'assets/json/bear plank avec kickback.json',
    'assets/json/cercles jambes tendues.json',
    'assets/json/ciseaux.json',
    'assets/json/cocon abdominaux.json',
    'assets/json/cercles jambes tendues.json',
  ];

  @override
  Widget build(BuildContext context) {
    var homeScreenProvider = Provider.of<HomeScreenProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    var exercisesScreenProvider = Provider.of<ExercisesScreenProvider>(context);

    return SafeArea(
      child: Scaffold(
        floatingActionButton: floatingActionButton(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => AddPictureScreen(
                  shoulder: homeScreenProvider.shoulder,
                  filteredshoulder: homeScreenProvider.filteredshoulder,
                  abs: homeScreenProvider.abs,
                  filteredabs: homeScreenProvider.filteredabs,
                  triceps: homeScreenProvider.triceps,
                  filteredTriceps: homeScreenProvider.filteredTriceps,
                  biceps: homeScreenProvider.biceps,
                  filteredBiceps: homeScreenProvider.filteredBiceps,
                  gluteal: homeScreenProvider.gluteal,
                  filteredgluteal: homeScreenProvider.filteredGluteal,
                  chest: homeScreenProvider.chest,
                  filteredChest: homeScreenProvider.chest,
                ),
              ),
            );
          },
          colors: iconColor,
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AnimationSearchBar(
            onChanged: (text) {
              // Add your logic here for handling text changes in the search bar
              homeScreenProvider.filterLists(text);
            },
            searchTextEditingController: homeScreenProvider.searchController,
            backIcon: Icons.arrow_back_ios_new,
            backIconColor: listTileEditColor,
            isBackButtonVisible: true,
            closeIconColor: listTileEditColor,
            centerTitle: languageProvider.translate('app_title'),
            hintText: languageProvider.translate('search'),

            centerTitleStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 16.0,

            ),
            hintStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
            ),
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            cursorColor: Colors.lightBlue.shade300,
            duration: const Duration(milliseconds: 500),
            searchFieldHeight: 35,
            searchBarHeight: 50,
            searchBarWidth: MediaQuery.of(context).size.width - 20,
            horizontalPadding: 5,
            verticalPadding: 0,
            searchIconColor: Colors.white.withOpacity(.7),
            searchFieldDecoration: BoxDecoration(
              color: Colors.blueGrey.shade700,
              border: Border.all(
                color: Colors.black.withOpacity(.2),
                width: .5,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    normalText(
                      title: languageProvider.translate('category_exercise'),
                      textSize: 22.0,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: exerciseCategories.asMap().entries.map((entry) {
                          int index = entry.key;
                          String category = entry.value;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              clipBehavior: Clip.antiAlias,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedCategory == category
                                      ? buttonColors
                                      : listTileEditColor,
                                ),
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: MediaQuery.of(context).size.height * 0.1,
                                child: cateogryExerciseTab(
                                  exerciseCategories[index],
                                  // languageProvider.translate('exercise_categories')[index],
                                  exerciseCategoriesimages[index],
                                  // Check if the category is selected
                                      () {
                                    setState(() {
                                      selectedCategory = category;

                                      print(languageProvider.translate('exercise_categories')[index]);

                                    });
                                  },
                                  context,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    ValueListenableBuilder<Box>(
                      valueListenable: selectedCategory == 'Chest'
                          ? BoxesClass.getChestData().listenable()
                          : selectedCategory == 'Biceps'
                          ? BoxesClass.getBicepsData().listenable()
                          : selectedCategory == 'Triceps'
                          ? BoxesClass.getTricepsData().listenable()
                          : selectedCategory == 'Abs'
                          ? BoxesClass.getabs().listenable()
                          : selectedCategory == 'Gluteal'
                          ? BoxesClass.getglutealData().listenable()
                          : BoxesClass.getshoulder().listenable(), // Use the correct box here
                      builder: (context, box, _) {
                        return Column(
                          children: List.generate(
                            selectedCategory == 'Chest'
                                ? homeScreenProvider.chest.length
                                : selectedCategory == 'Biceps'
                                ? homeScreenProvider.biceps.length
                                : selectedCategory == 'Triceps'
                                ? homeScreenProvider.triceps.length
                                : selectedCategory == 'Abs'
                                ? homeScreenProvider.abs.length
                                : selectedCategory == 'Gluteal'
                                ? homeScreenProvider.gluteal.length
                                : homeScreenProvider.shoulder.length,
                                (index) {
                              final imageItem = selectedCategory == 'Chest'
                                  ? homeScreenProvider.chest[index]
                                  : selectedCategory == 'Biceps'
                                  ? homeScreenProvider.biceps[index]
                                  : selectedCategory == 'Triceps'
                                  ? homeScreenProvider.triceps[index]
                                  : selectedCategory == 'Abs'
                                  ? homeScreenProvider.abs[index]
                                  : selectedCategory == 'Gluteal'
                                  ? homeScreenProvider.gluteal[index]
                                  : homeScreenProvider.shoulder[index];

                              // Apply filtering here
                              if (imageItem.title
                                  .toString()
                                  .toLowerCase()
                                  .contains(homeScreenProvider.searchController.text.toLowerCase())) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  child: CustomSlider(
                                    deleteOnPressed: (context) {
                                      homeScreenProvider.deleteImageItem(imageItem);
                                    },
                                    // editOnPressed: (BuildContext) {
                                    //   // showEditDialog(context,index);
                                    //
                                    //
                                    // imageItem.isAsset == true ?
                                    // CustomMotionToast.showSuccessToast(
                                    //     context,
                                    //     'This field will be implemented',
                                    //
                                    //   ); :
                                    // },
                                    editOnPressed: (context) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: blackColor,
                                            elevation: 10,
                                            title: largeText(title: 'Edit Exercise'),
                                            content: EditExerciseForm(
                                              initialName: imageItem.title.toString(),
                                              initalDescription: imageItem.description.toString(),
                                              onEdit: (newName, newDescription) {
                                                if (selectedCategory == 'Chest') {
                                                  homeScreenProvider.chest[index].title = newName;
                                                  homeScreenProvider.chest[index].description = newDescription;
                                                } else if (selectedCategory == 'Biceps') {
                                                  homeScreenProvider.biceps[index].title = newName;
                                                  homeScreenProvider.biceps[index].description = newDescription;
                                                } else if (selectedCategory == 'Triceps') {
                                                  homeScreenProvider.triceps[index].title = newName;
                                                  homeScreenProvider.triceps[index].description = newDescription;
                                                } else if (selectedCategory == 'Abs') {
                                                  homeScreenProvider.abs[index].title = newName;
                                                  homeScreenProvider.abs[index].description = newDescription;
                                                } else if (selectedCategory == 'Gluteal') {
                                                  homeScreenProvider.gluteal[index].title = newName;
                                                  homeScreenProvider.gluteal[index].description = newDescription;
                                                } else {
                                                  homeScreenProvider.shoulder[index].title = newName;
                                                  homeScreenProvider.shoulder[index].description = newDescription;
                                                }
                                                // Update the UI
                                                setState(() {});

                                                // Close the dialog
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                                          );
                                        },
                                      );
                                    },
                                    child: ListTile(
                                      contentPadding: EdgeInsets.only(
                                        left: 15,
                                        top: 5,
                                        bottom: 5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      tileColor: listTileColor,
                                      trailing: widget.isExerciseScreen
                                          ? HomeScreenAddExerciseButton(
                                        onTap: () {
                                          // add data into exercise list
                                          imageItem.isAsset
                                              ? imageItem.imagePath
                                              : imageItem.imagePath;
                                          homeScreenProvider.addExercise(
                                            imageItem.title.toString(),
                                            imageItem.imagePath,
                                            widget.workoutDay!,
                                          );
                                          setState(() {
                                            print('imageURl : ${imageItem.imagePath}');
                                            print('setName : ${imageItem.title.toString()}');
                                          });
                                          Navigator.pushReplacement(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) => ExercisesScreen(widget.workoutDay!),
                                            ),
                                          );
                                        },
                                      )
                                          : Container(
                                        height: 5,
                                        width: 5,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => ViewPictureScreen(
                                              imageItem: imageItem,
                                            ),
                                          ),
                                        );
                                      },
                                      title: listTileText(
                                        title: imageItem.title.toString().toUpperCase(),
                                      ),
                                      leading: imageItem.isAsset
                                          ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.15,
                                          height: MediaQuery.of(context).size.height * 0.15,
                                          child: LottieBuilder.asset(
                                            imageItem.imagePath,
                                            animate: false,
                                            // repeat: false,
                                          ),
                                        ),
                                      )
                                          : ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image(
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context).size.width * 0.15,
                                          height: MediaQuery.of(context).size.height * 0.15,
                                          image: FileImage(File(imageItem.imagePath ?? '')),
                                        ),
                                      ),
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
      ),
    );
  }
}