import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:mikococo/exercide/ExerciseScreenProvider.dart';
import 'package:mikococo/exercide/edit_exercise.dart';
import 'package:mikococo/homescreen/home_screen.dart';
import 'package:mikococo/sets/SetsScreen.dart';
import 'package:mikococo/widgets_common/emptybox.dart';
import 'package:mikococo/widgets_common/our_button.dart';
import 'package:provider/provider.dart';
import '../consts/colors.dart';
import '../consts/strnigs.dart';
import '../module/models.dart';
import '../widgets_common/text_widgets.dart';

class ExercisesScreen extends StatelessWidget {
  final WorkoutDay workoutDay;

  ExercisesScreen(this.workoutDay);

  Widget build(BuildContext context) {
    var exercisesScreenProvider = Provider.of<ExercisesScreenProvider>(context);
    exercisesScreenProvider.setWorkoutDay(workoutDay);
    return Scaffold(
      appBar: AppBar(
        leading: LeadingIcon(),
        centerTitle: true,
        title: normalText(title: appName),
      ),
      body: Consumer<ExercisesScreenProvider>(
        builder: (context, exercisesScreenProvider, _) {
          if (exercisesScreenProvider.exercises.isEmpty) {
            // If there are no routines, display a message
            return emptyBox(
                svgPicture: 'assets/svg/emptybox.svg',
                largetexttitle: 'No items',
                normaltexttitle:
                    "You don't have any Exercises. Add a Exercise using the '+' button.");
          }
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 8),
                  child: normalText(
                      title: 'Exercise ( ${workoutDay.name} )',
                      textSize: 20.0,
                      weight: FontWeight.w400),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: exercisesScreenProvider.exercises.length,
                  itemBuilder: (context, index) {
                    return CustomSlider(
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(
                              left: 15, top: 5, bottom: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: listTileColor,
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => SetsScreen(
                                        exercisesScreenProvider
                                            .exercises[index])));
                          },

                          leading: exercisesScreenProvider
                                  .exercises[index].image
                                  .toString()
                                  .contains('assets/json')
                              ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                                  clipBehavior: Clip.antiAlias,
                                  width: MediaQuery.of(context).size.width * 0.15,
                                  height: MediaQuery.of(context).size.height * 0.15,
                                  child: Lottie.asset(
                                    exercisesScreenProvider
                                        .exercises[index].image
                                        .toString(),
                                    repeat: false,
                                    fit: BoxFit.cover,
                                  ))
                              : Container(
                            clipBehavior: Clip.antiAlias,
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                isAntiAlias:true,
                                image: FileImage(File(
                                  exercisesScreenProvider
                                      .exercises[index].image
                                      .toString())) as ImageProvider,
                              ),)
                            ),


                          title: listTileText(
                              title: exercisesScreenProvider
                                  .exercises[index].name),
                        ),
                        deleteOnPressed: (context) {
                          exercisesScreenProvider.deleteExercise(index);
                        },
                        editOnPressed: (context) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: blackColor,
                                elevation: 10,
                                title: largeText(title: 'Edit Exercise'),
                                content: EditExerciseForm(
                                  initialName: exercisesScreenProvider
                                      .exercises[index].name,
                                  onEdit: (String newName) {
                                    exercisesScreenProvider.updateExercise(
                                        index, newName);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                              );
                            },
                          );
                        });
                  },
                ),

              ],
            ),
          );
        },
      ),
      floatingActionButton: floatingActionButton(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (ctx) => HomeScreen(
                workoutDay,
                isExerciseScreen: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
