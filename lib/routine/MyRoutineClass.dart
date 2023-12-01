import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mikococo/calender/calender_screen.dart';
import 'package:mikococo/homescreen/home_screen.dart';
import 'package:mikococo/routine/RoutineProvider.dart';
import 'package:mikococo/routine/edit_routine.dart';
import 'package:mikococo/setting/motionToastConstructor.dart';
import 'package:mikococo/setting/settingScreen.dart';
import 'package:mikococo/timer/timer_screen.dart';
import 'package:mikococo/widgets_common/emptybox.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';
import 'package:mikococo/workout/workoutScreen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../consts/colors.dart';
import '../module/models.dart';
import '../widgets_common/our_button.dart';
import 'add_routine.dart';

class MyRoutinesScreen extends StatelessWidget {
  Future<void> _launchYoutubeVideo(String url) async {
    await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    var routineProvider = Provider.of<RoutineProvider>(context, listen: false);
    routineProvider.loadRoutines();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                icon: SvgPicture.asset(
                  'assets/svg/applogo.svg',
                  width: 50,
                  height: 50,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                  debugPrint('sdfsdf');
                },
                tooltip:
                    MaterialLocalizations.of(context).openAppDrawerTooltip);
          },
        ),
        centerTitle: true,
        title: normalText(title: 'My Routines'),
        actions: [
          trailingbutton(
            onTap: () {
              CustomMotionToast.showSuccessToast(context, 'This Option will implemented', 'in next Milestone');
            },
            svgAsset: 'assets/svg/language.svg',
            svgColor: leadingBtnColor,
          ),
        ],
      ),
      drawer: Drawer(
          backgroundColor: blackColor,
          child: ListView(
            children: [
              DrawerHeader(
                child: SvgPicture.asset('assets/svg/applogo.svg',
                    height: 100, width: 100),
              ),
              listTileDrawer(
                assetsvg: 'assets/svg/dumbel.svg',
                title: 'My Exercises',
                ontap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (ctx) => HomeScreen(null)));
                },
              ),
              listTileDrawer(
                assetsvg: 'assets/svg/calnder.svg',
                title: 'Diary',
                ontap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (ctx) => ShareScreen()));
                },
              ),

              listTileDrawer(
                assetsvg: 'assets/svg/clock.svg',
                title: 'Timer',
                ontap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (ctx) => TimerScreen()));
                },
              ),
              // listTileDrawer(
              //   assetsvg: 'assets/svg/personicon.svg',
              //   title: 'Measurements',
              //   ontap: () {
              //
              //   },
              // ),
              listTileDrawer(
                assetsvg: 'assets/svg/setting.svg',
                title: 'Setting',
                ontap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (ctx) => SettingScreen()));
                },
              ),
              listTileDrawer(
                assetsvg: 'assets/svg/facebooklogo.svg',
                title: 'Facebook',
                ontap: () async {
                  const facebookProfileUrl = 'https://www.google.com';
                  _launchYoutubeVideo(facebookProfileUrl);
                },
              ),
              listTileDrawer(
                assetsvg: 'assets/svg/sync.svg',
                title: 'Sync',
                ontap: () {
                  CustomMotionToast.showSuccessToast(context, "This option will be implemented", "Next Milestone");

                },
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.16,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 38.0, right: 38),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      CustomMotionToast.showSuccessToast(context, 'This Feature will be implemented', 'in next milestone');
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                          color: goldenColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/premiumlogo.svg',
                              color: whiteColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Get Premium',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
      body: Consumer<RoutineProvider>(builder: (context, routineProvider, _) {
        List<Routine> routines = routineProvider.routines;
        if (routines.isEmpty) {
          // If there are no routines, display a message
          return emptyBox(
              svgPicture: 'assets/svg/emptybox.svg',
              largetexttitle: 'No items',
              normaltexttitle:
              "You don't have any Routines. Add a Routine using the '+' button.");
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
                      physics: NeverScrollableScrollPhysics(),
                      onReorder: (oldIndex, newIndex) {
                        routineProvider.updateRoutineList(oldIndex, newIndex);
                      },
                      itemCount: routine.length,
                      itemBuilder: (context, index) {
                        final currentroutine = routine[index];
                        return CustomSlider(
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            tileColor: listTileColor,
                            leading: Container(
                              decoration: BoxDecoration(
                                  color: Color(int.parse(
                                          currentroutine.avatarColor
                                              .replaceFirst('#', ''),
                                          radix: 16) |
                                      0xff000000),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              height: MediaQuery.of(context).size.height * .1,
                              width: MediaQuery.of(context).size.width * .15,
                              child: Center(
                                  child: Text(
                                currentroutine.leadingword.toUpperCase(),
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
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.02,
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
                          deleteOnPressed: (context) {
                            routineProvider.deleteRoutine(index);
                          },
                          editOnPressed: (context) {
                            {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Theme(
                                      data: ThemeData(
                                        canvasColor: blackColor,
                                      ),
                                      child: AlertDialog(
                                        title: listTileText(
                                            title: 'Edit Routine',
                                            weight: FontWeight.w900),
                                        backgroundColor: blackColor,
                                        elevation: 10,
                                        content: EditRoutineForm(
                                          initialName: currentroutine.name,
                                          onEdit: (String newName) {
                                            routineProvider.updateRoutine(
                                                index, newName);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 5),
                                      ),
                                    );
                                  });
                            }
                          },
                          key: ValueKey<int>(index),
                        );
                      },
                    ),
                  ],
                ),
              );
            });
      }),
      floatingActionButton: floatingActionButton(
        onTap: () {
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
