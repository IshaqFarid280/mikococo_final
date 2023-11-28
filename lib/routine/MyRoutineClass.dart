import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu), // Replace with your custom icon
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        centerTitle: true,
        title: normalText(title: 'My Routines'),
        actions: [
          trailingbutton(
            onTap: () {},
            svgAsset: 'assets/svg/language.svg',
            svgColor: leadingBtnColor,
          ),
        ],
      ),
      body: Consumer<RoutineProvider>(builder: (context, routineProvider, _) {
        List<Routine> routines = routineProvider.routines;
        if (routines.isEmpty) {
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

        return ValueListenableBuilder<Box<Routine>>(
            valueListenable: Hive.box<Routine>('RoutineBox').listenable(),
            builder: (context, Box<Routine> box, _) {
              List<Routine> routine = box.values.toList();
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics:const NeverScrollableScrollPhysics(),
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
                                        context: context,
                                        builder: (context) {
                                          return Theme(
                                            data: ThemeData(
                                              canvasColor: Colors.black,
                                            ),
                                            child: AlertDialog(
                                              title: listTileText(title: 'Edit Routine', weight: FontWeight.w900),
                                              backgroundColor: Colors.black,
                                              content: EditRoutineForm(
                                                initialName: currentroutine.name,
                                                onEdit: (String newName) {
                                                  routineProvider.updateRoutine(
                                                      index, newName);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                            ),
                                          );
                                        });
                                  },
                                  backgroundColor: greyColor,
                                  icon: Icons.edit,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                // delete option
                                SlidableAction(
                                  onPressed: (context) {
                                    routineProvider.deleteRoutine(index);
                                  },
                                  backgroundColor: deleteColor,
                                  icon: Icons.delete,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ],
                            ),
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                tileColor: listTileColor,
                                leading: Container(
                                  decoration: BoxDecoration(
                                      color:  Color(int.parse(
                                          currentroutine.avatarColor
                                              .replaceFirst('#', ''),
                                          radix: 16) |
                                      0xff000000),
                                      borderRadius: BorderRadius.all(Radius.circular(10))),
                                  height: MediaQuery.of(context).size.height * .1,
                                  width: MediaQuery.of(context).size.width * .15,
                                  child: Center(
                                      child: Text(
                                        currentroutine.leadingword
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 22,
                                        ),
                                      )),
                                ),

                                title: listTileText(
                                  title: currentroutine.name.toUpperCase(),
                                ),
                                subtitle: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.gps_fixed_outlined,
                                      color: iconColor,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.02,
                                    ),
                                    listTileText(
                                      textSize: 12.0,
                                      title: currentroutine.description,
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
                            ));
                      },
                    ),
                  ],
                ),
              );
            });
      }),
      floatingActionButton: floatingActionButton(
        onTap: (){
      Navigator.of(context).push(CupertinoPageRoute(
        builder: (ctx) => AddRoutineForm(onAdd: (String name, String desc,
            String leadword, String avatarCOlor) {
          routineProvider.addRoutine(name, desc, leadword, avatarCOlor);
        }),
      ));
    },

      ),
    );
  }
}
