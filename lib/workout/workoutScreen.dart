  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
  import 'package:mikococo/exercide/exercise_screen.dart';
  import 'package:mikococo/workout/WorkoutScreenProvider.dart';
  import 'package:mikococo/workout/edit_workout.dart';
  import 'package:mikococo/workout/work_out_froum.dart';
  import 'package:provider/provider.dart';
  import '../module/models.dart';

  class WorkoutDaysScreen extends StatefulWidget {
    final Routine routine;

    WorkoutDaysScreen(this.routine);

    @override
    State<WorkoutDaysScreen> createState() => _WorkoutDaysScreenState();
  }

  class _WorkoutDaysScreenState extends State<WorkoutDaysScreen> {
    // late WorkoutDaysScreenProvider workoutDaysScreenProvider;
    //
    // @override
    // void initState() {
    //   super.initState();
    //   workoutDaysScreenProvider =
    //       Provider.of<WorkoutDaysScreenProvider>(context, listen: false);
    //   workoutDaysScreenProvider.loadWorkoutDays(widget.routine);
    // }
    // late WorkoutDaysScreenProvider workoutDaysScreenProvider;
    //
    // @override
    // void initState() {
    //   super.initState();
    //   workoutDaysScreenProvider = Provider.of<WorkoutDaysScreenProvider>(context, listen: false);
    //   workoutDaysScreenProvider.loadWorkoutDays(widget.routine);
    // }

    @override
    Widget build(BuildContext context) {


      var workoutDaysScreenProvider = Provider.of<WorkoutDaysScreenProvider>(context);
      workoutDaysScreenProvider.loadWorkoutDays(widget.routine);

      return Scaffold(
        appBar: AppBar(
          title: Text('Workout Days for ${widget.routine.name}'),
        ),
        body: Consumer<WorkoutDaysScreenProvider>(
          builder: (context, workoutDaysScreenProvider, _) {
            List<WorkoutDay> workoutDay = workoutDaysScreenProvider.workoutDays;

            if (workoutDay.isEmpty) {
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

            return ReorderableListView.builder(
              onReorder: (oldIndex, newIndex) {
                debugPrint('Reorderable: $oldIndex to ' + '$newIndex');
                  workoutDaysScreenProvider.reorderWorkoutDays(oldIndex, newIndex, widget.routine);

                   },
              itemCount: workoutDay.length,
              itemBuilder: (context, index) {

                final currentworkout = workoutDay[index];
                // print('Building item at index: $index');
                return Slidable(
                  key: ValueKey(workoutDay[index]),

                  endActionPane: ActionPane(
                    motion: StretchMotion(),
                    children: [
                      // settings option
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Edit Workout Day'),
                                content: EditWorkoutDayForm(
                                  initialName: currentworkout.name,
                                  onEdit: (String newName) {
                                    workoutDaysScreenProvider.updateWorkoutDay(
                                        index, newName, widget.routine);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              );
                            },
                          );
                        },
                        backgroundColor: Colors.grey.shade800,
                        icon: Icons.edit,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // delete option
                      SlidableAction(
                        onPressed: (context) {
                          workoutDaysScreenProvider.deleteWorkoutDay(index, widget.routine);
                        },
                        backgroundColor: Colors.red.shade400,
                        icon: Icons.delete,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ],
                  ),

                  child: ListTile(
                    // key: Key('$index'),

                    leading: CircleAvatar(
                      backgroundColor: Color(
                        int.parse(
                          currentworkout.avatarColors
                                  .replaceFirst('#', ''),
                              radix: 16,
                            ) |
                            0xff000000,
                      ),
                      child: Text(
                        currentworkout.leadingword,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(currentworkout.name),
                    onTap: () {
                      print('Tapped on item at index: $index');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ExercisesScreen(
                              workoutDaysScreenProvider.workoutDays
                                  .elementAt(index)),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('Add button pressed');
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (ctx) => AddWorkoutDayForm(
                  onAdd: (String name, String leadingtext,
                      String leadingavatarcolor) {
                    workoutDaysScreenProvider.addWorkoutDay(
                        name, leadingtext, leadingavatarcolor, widget.routine);
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
