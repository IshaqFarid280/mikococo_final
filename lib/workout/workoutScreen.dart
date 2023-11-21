import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mikococo/exercide/exercise_screen.dart';
import 'package:mikococo/workout/WorkoutScreenProvider.dart';
import 'package:mikococo/workout/edit_workout.dart';
import 'package:mikococo/workout/work_out_froum.dart';
import 'package:provider/provider.dart';
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
        title: Text('Workout Days for ${routine.name}'),
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
          return ListView.builder(
            itemCount: workoutDaysScreenProvider.workoutDays.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(
                    int.parse(
                          workoutDaysScreenProvider
                              .workoutDays[index].avatarColors
                              .replaceFirst('#', ''),
                          radix: 16,
                        ) |
                        0xff000000,
                  ),
                  child: Text(
                    workoutDaysScreenProvider.workoutDays[index].leadingword,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(workoutDaysScreenProvider.workoutDays[index].name),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ExercisesScreen(
                          workoutDaysScreenProvider.workoutDays
                              .elementAt(index)),
                    ),
                  );
                },
                trailing: IconButton(
                  onPressed: () {
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
                  },
                  icon: Icon(Icons.edit),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
        child: Icon(Icons.add),
      ),
    );
  }
}
