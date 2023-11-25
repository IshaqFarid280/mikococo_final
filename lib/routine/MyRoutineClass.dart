import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mikococo/consts/strnigs.dart';
import 'package:mikococo/routine/RoutineProvider.dart';
import 'package:mikococo/routine/edit_routine.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';
import 'package:mikococo/workout/workoutScreen.dart';
import 'package:provider/provider.dart';
import '../consts/colors.dart';
import '../module/models.dart';
import '../widgets_common/our_button.dart';
import 'add_routine.dart';

class MyRoutinesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var routineProvider = Provider.of<RoutineProvider>(context, listen: false);
    routineProvider.loadRoutines();

    // void addRoutine(String name, String des, String leadword, String avatarColor) {
    //   final routine = Routine(name, des, leadword, avatarColor, []);
    //   Hive.box<Routine>('RoutineBox').add(routine);
    // }
    //
    // void deleteRoutine(int index) {
    //   Hive.box<Routine>('RoutineBox').deleteAt(index);
    // }
    //
    // void updateRoutine(int index, String newName) {
    //   final routine = Hive.box<Routine>('RoutineBox').getAt(index);
    //   if (routine != null) {
    //     routine.name = newName;
    //     routine.save();
    //   }
    // }
    //
    //
    // var routineBox = Hive.box<Routine>('RoutineBox');
    // List<Routine> routines = routineBox.values.toList();

    return Scaffold(
      appBar: AppBar(
        leading: LeadingIcon(icon: Icons.menu,),
        centerTitle: true,
        title: normalText(title: appName),
        actions: [
          AddThingsIcon(onTap: (){},icon:Icons.language_outlined,),
        ],
      ),
      body: Consumer<RoutineProvider>(
          builder: (context, routineProvider, _) {
            List<Routine> routines = routineProvider.routines;
            if (routines.isEmpty) {
              // If there are no routines, display a message
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/emptyIcon.png', height: 100, width: 100,),
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

            return ValueListenableBuilder<Box<Routine>>(
                valueListenable: Hive.box<Routine>('RoutineBox').listenable(),
                builder: (context, Box<Routine> box, _) {
                  List<Routine> routine = box.values.toList();
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          normalText(title: 'My Routines'),
                          SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
                          ReorderableListView.builder(
                            shrinkWrap: true,
                            physics:NeverScrollableScrollPhysics(),
                            onReorder: (oldIndex, newIndex) {
                              routineProvider.updateRoutineList(oldIndex, newIndex);
                            },
                            itemCount: routine.length,
                            itemBuilder: (context, index) {
                              final currentroutine = routine[index];
                              return Slidable(
                                  key: Key('$index'),
                                  endActionPane: ActionPane(
                                    motion: StretchMotion(),
                                    children: [
                                      // settings option
                                      SlidableAction(
                                        onPressed: (BuildContext context) {
                                          showDialog(
                                              context: context, builder: (context) {
                                            return AlertDialog(
                                              title: Text('Edit Routine'),
                                              content: EditRoutineForm(
                                                initialName: currentroutine.name,
                                                onEdit: (String newName) {
                                                  routineProvider.updateRoutine(index, newName);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            );
                                          });
                                        },
                                        backgroundColor: Colors.grey.shade800,
                                        icon: Icons.edit,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      // delete option
                                      SlidableAction(
                                        onPressed: (context) {
                                          routineProvider.deleteRoutine(index);
                                        },
                                        backgroundColor: Colors.red.shade400,
                                        icon: Icons.delete,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    color:  backGroundColor ,
                                    margin:const EdgeInsets.only(top:5),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      tileColor: listTileColor,
                                      leading: CircleAvatar(
                                        radius:25,
                                        // backgroundColor: Color(int.parse("FF0000", radix: 16) | 0xFF000000),
                                        backgroundColor: Color(int.parse(
                                            currentroutine.avatarColor.replaceFirst(
                                                '#', ''),
                                            radix: 16) |
                                        0xff000000),
                                        child: listTileText(title :currentroutine.leadingword.toUpperCase(),),
                                      ),
                                      title: listTileText(
                                        title: currentroutine.name.toUpperCase(),
                                      ),
                                      subtitle: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.gps_fixed_outlined,color: iconColor,size:20,),
                                          SizedBox(width: MediaQuery.sizeOf(context).width * 0.02,),
                                          listTileText(
                                              title:currentroutine.description,
                                            weight: FontWeight.w300,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                WorkoutDaysScreen(currentroutine),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                });

          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (ctx) => AddRoutineForm(onAdd: (String name, String desc,
                  String leadword, String avatarCOlor) {
                routineProvider.addRoutine(name, desc, leadword, avatarCOlor);
              })));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
