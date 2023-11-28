import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mikococo/exercide/exercise_screen.dart';
import 'package:mikococo/widgets_common/our_button.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';
import 'package:mikococo/workout/WorkoutScreenProvider.dart';
import 'package:mikococo/workout/edit_workout.dart';
import 'package:mikococo/workout/work_out_froum.dart';
import 'package:mikococo/workout/workoutday_widget.dart';
import 'package:provider/provider.dart';
import '../consts/colors.dart';
import '../module/models.dart';

class WorkoutDaysScreen extends StatelessWidget {
  final Routine routine;

  WorkoutDaysScreen(this.routine);

  @override
  Widget build(BuildContext context) {
    var workoutDaysScreenProvider =
        Provider.of<WorkoutDaysScreenProvider>(context);
    workoutDaysScreenProvider.loadWorkoutDays(routine);

    return Scaffold(
      appBar: AppBar(
        leading:  LeadingIcon(),
        centerTitle: false,
        title: normalText(title:'Workout Days ${routine.name}'),
      ),
      body: Consumer<WorkoutDaysScreenProvider>(
        builder: (context, workoutDaysScreenProvider, _) {
          if (workoutDaysScreenProvider.workoutDays.isEmpty) {
            // If there are no routines, display a message
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/emptyIcon.png',
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No Items',
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    "You don't have any routines. Add a routine using the '+' button.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics:const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
                  WorkoutdayContainer(routineName: routine.name.toString(),),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
                  ListView.builder(
                    shrinkWrap: true,
                    physics:const NeverScrollableScrollPhysics(),
                    itemCount: workoutDaysScreenProvider.workoutDays.length,
                    itemBuilder: (context, index) {
                      return CustomSlider(child:ListTile(
                        contentPadding: EdgeInsets.only(left: 8,top: 5,bottom: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tileColor: listTileColor,
                        leading: Container(
                          decoration: BoxDecoration(
                              color:  Color(
                                int.parse(
                                  workoutDaysScreenProvider
                                      .workoutDays[index].avatarColors
                                      .replaceFirst('#', ''),
                                  radix: 16,
                                ) |
                                0xff000000,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          height: MediaQuery.of(context).size.height * .1,
                          width: MediaQuery.of(context).size.width * .15,
                          child: Center(
                              child: Text(
                                workoutDaysScreenProvider.workoutDays[index].leadingword.toUpperCase(),
                                style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22,
                                ),
                              )),
                        ),
                        title: listTileText(title :workoutDaysScreenProvider.workoutDays[index].name.toUpperCase(),textSize:18.0),
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => ExercisesScreen(
                                  workoutDaysScreenProvider.workoutDays
                                      .elementAt(index)),
                            ),
                          );
                        },
                      ), deleteOnPressed:(context) {
                        workoutDaysScreenProvider.deleteWorkoutDay(index, routine);
                      },
                        editOnPressed: (context)
                      {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Edit Workout Day'),
                              content: EditWorkoutDayForm(
                                initialName: workoutDaysScreenProvider
                                    .workoutDays[index].name,
                                onEdit: (String newName) {
                                  workoutDaysScreenProvider.updateWorkoutDay(
                                      index, newName, routine);
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          },
                        );
                      },);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: floatingActionButton(
        onTap: (){

          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (ctx) => AddWorkoutDayForm(
                onAdd: (String name, String leadingtext,
                    String leadingavatarcolor) {
                  workoutDaysScreenProvider.addWorkoutDay(
                      name, leadingtext, leadingavatarcolor, routine);
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
