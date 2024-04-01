import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mikococo/calender/calender_screen.dart';
import 'package:mikococo/homescreen/home_screen.dart';
import 'package:mikococo/l10n/languageProvider.dart';
import 'package:mikococo/routine/RoutineProvider.dart';
import 'package:mikococo/routine/edit_routine.dart';
import 'package:mikococo/setting/motionToastConstructor.dart';
import 'package:mikococo/setting/settingScreen.dart';
import 'package:mikococo/timer/timer_screen.dart';
import 'package:mikococo/widgets_common/emptybox.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';
import 'package:mikococo/workout/workoutScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../consts/colors.dart';
import '../module/models.dart';
import '../widgets_common/our_button.dart';
import 'add_routine.dart';

class MyRoutinesScreen extends StatefulWidget {
  @override
  State<MyRoutinesScreen> createState() => _MyRoutinesScreenState();
}

class _MyRoutinesScreenState extends State<MyRoutinesScreen> {

  final _routineBox = Hive.box<Routine>('RoutineBox');
  final _dayBox = Hive.box<WorkoutDay>('WorkoutDaysBox');
  final _dayexerciseBox = Hive.box<Exercise>('ExercisesBox');
  String _currentLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('language_code') ?? 'en';

    // await _loadDemoData();
    // await _updateDemoData();
  }

  // if (Hive.box<Routine>('RoutineBox').isEmpty || Hive.box<WorkoutDay>('WorkoutDaysBox').isEmpty || Hive.box<Exercise>('ExercisesBox').isEmpty) {
  // await initializeDummyData();
  // }

  // Future<void> _loadDemoData() async {
  //   // Dummy Routines
  //   if (_routineBox.isEmpty ||  _dayBox.isEmpty || _dayexerciseBox.isEmpty) {
  //     // _routineBox.add(Routine('Body weight', '3 Monhs me Mass Gain Karna 😮', 'e', redColor.value.toRadixString(16), []));
  //     // _routineBox.add(Routine('Full body','3 Monhs me Mass Gain Karna 😮', 'g', blackColor.value.toRadixString(16), []));
  //     // _routineBox.add(Routine('Mass gain','3 Monhs me Mass Gain Karna 😮', 'a', greyColor.value.toRadixString(16), []));
  //     //
  //     // _dayBox.add(WorkoutDay('Day 1', 's', redColor.value.toRadixString(16), []));
  //     // _dayBox.add(WorkoutDay('Day 2', 'q', greenColor.value.toRadixString(16), []));
  //     // _dayBox.add(WorkoutDay('Day 3', 'p',greyColor.value.toRadixString(16),[]));
  //     //
  //     // _dayexerciseBox.add(Exercise('Push-upps','assets/json/crunch a la poulie pour les obliques.json',null,));
  //     // _dayexerciseBox.add(Exercise('Squats','assets/json/crunch a la poulie pour les obliques.json',null));
  //     // _dayexerciseBox.add(Exercise('Pull-ups','assets/json/crunch a la poulie pour les obliques.json',null));
  //     // // await exercisesBox.addAll([exercise1, exercise2, exercise3]);
  //     //
  //     // routine1.workoutDays.add(workoutDay1.key);
  //     // routine2.workoutDays.add(workoutDay2.key);
  //     // routine3.workoutDays.add(workoutDay3.key);
  //
  //     final routineBox = Hive.box<Routine>('RoutineBox');
  //     final routine1 = Routine('Body weight', '3 Monhs me Mass Gain Karna 😮', 'e', redColor.value.toRadixString(16), []);
  //     final routine2 = Routine('Full body','3 Monhs me Mass Gain Karna 😮', 'g', blackColor.value.toRadixString(16), []);
  //     final routine3 = Routine('Mass gain','3 Monhs me Mass Gain Karna 😮', 'a', greyColor.value.toRadixString(16), []);
  //     await routineBox.addAll([routine1, routine2, routine3]);
  //     // Dummy Workout Days
  //     final workoutDaysBox = Hive.box<WorkoutDay>('WorkoutDaysBox');
  //     final workoutDay1 = WorkoutDay('Day 1', 's', redColor.value.toRadixString(16), []);
  //     final workoutDay2 = WorkoutDay('Day 2', 'q', greenColor.value.toRadixString(16), []);
  //     final workoutDay3 = WorkoutDay('Day 3', 'p',greyColor.value.toRadixString(16),[]);
  //     await workoutDaysBox.addAll([workoutDay1, workoutDay2, workoutDay3]);
  //     // Dummy Exercises
  //     final exercisesBox = Hive.box<Exercise>('ExercisesBox');
  //     final exercise1 = Exercise('Push-upps','assets/json/crunch a la poulie pour les obliques.json',null,);
  //     final exercise2 = Exercise('Squats','assets/json/crunch a la poulie pour les obliques.json',null);
  //     final exercise3 = Exercise('Pull-ups','assets/json/crunch a la poulie pour les obliques.json',null);
  //     await exercisesBox.addAll([exercise1, exercise2, exercise3]);
  //     // Link routines with workout days
  //     routine1.workoutDays.add(workoutDay1.key);
  //     routine2.workoutDays.add(workoutDay2.key);
  //     routine3.workoutDays.add(workoutDay3.key);
  //     // Link workout days with exercises
  //     workoutDay1.exercises.add(exercise1.key);
  //     workoutDay2.exercises.add(exercise2.key);
  //     workoutDay3.exercises.add(exercise3.key);
  //     // Save changes
  //     await Future.wait([
  //       routine1.save(),
  //       routine2.save(),
  //       routine3.save(),
  //       workoutDay1.save(),
  //       workoutDay2.save(),
  //       workoutDay3.save(),
  //     ]);
  //   }
  //   // else{
  //   //   await _updateDemoData();
  //   // }
  //
  // }


  // Future<void> _updateDemoData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString('language_code', _currentLanguage);
  //
  //     switch (_currentLanguage) {
  //       case 'es':
  //       // Update data for Spanish
  //         final routineBox = Hive.box<Routine>('RoutineBox');
  //         final routine1 = Routine('Body weightes', '3 Monhs for spanish 😮', 'e', redColor.value.toRadixString(16), []);
  //         final routine2 = Routine('Full body','3 Monhs me Mass Gain Karna 😮', 'g', blackColor.value.toRadixString(16), []);
  //         final routine3 = Routine('Mass gain','3 Monhs me Mass Gain Karna 😮', 'a', greyColor.value.toRadixString(16), []);
  //         // await routineBox.addAll([routine1, routine2, routine3]);
  //         routineBox.putAt(0, routine1);
  //         routineBox.putAt(1, routine2);
  //         routineBox.putAt(2, routine3);
  //         // Dummy Workout Days
  //         final workoutDaysBox = Hive.box<WorkoutDay>('WorkoutDaysBox');
  //         final workoutDay1 = WorkoutDay('Day 1', 's', redColor.value.toRadixString(16), []);
  //         final workoutDay2 = WorkoutDay('Day 2', 'q', greenColor.value.toRadixString(16), []);
  //         final workoutDay3 = WorkoutDay('Day 3', 'p',greyColor.value.toRadixString(16),[]);
  //         // await workoutDaysBox.addAll([workoutDay1, workoutDay2, workoutDay3]);
  //         workoutDaysBox.putAt(0, workoutDay1);
  //         workoutDaysBox.putAt(1, workoutDay2);
  //         workoutDaysBox.putAt(2, workoutDay3);
  //         // Dummy Exercises
  //         final exercisesBox = Hive.box<Exercise>('ExercisesBox');
  //         final exercise1 = Exercise('Push-upps','assets/json/crunch a la poulie pour les obliques.json',null,);
  //         final exercise2 = Exercise('Squats','assets/json/crunch a la poulie pour les obliques.json',null);
  //         final exercise3 = Exercise('Pull-ups','assets/json/crunch a la poulie pour les obliques.json',null);
  //         // await exercisesBox.addAll([exercise1, exercise2, exercise3]);
  //         exercisesBox.putAt(0, exercise1);
  //         exercisesBox.putAt(1, exercise2);
  //         exercisesBox.putAt(2, exercise3);
  //
  //         // Link routines with workout days
  //
  //         routine1.workoutDays.add(workoutDay1.key);
  //         routine2.workoutDays.add(workoutDay2.key);
  //         routine3.workoutDays.add(workoutDay3.key);
  //         // Link workout days with exercises
  //         workoutDay1.exercises.add(exercise1.key);
  //         workoutDay2.exercises.add(exercise2.key);
  //         workoutDay3.exercises.add(exercise3.key);
  //         // Save changes
  //         await Future.wait([
  //           routine1.save(),
  //           routine2.save(),
  //           routine3.save(),
  //           workoutDay1.save(),
  //           workoutDay2.save(),
  //           workoutDay3.save(),
  //         ]);
  //
  //     //   _routineBox.putAt(0, Routine('Body weight for Spanish', '3 Monhs me Mass Gain Karna 😮', 'e', redColor.value.toRadixString(16), []));
  //       //   _routineBox.putAt(1, Routine('Full body', '3 Monhs me Mass Gain Karna 😮', 'g', blackColor.value.toRadixString(16), []));
  //       //   _routineBox.putAt(2, Routine('Mass gain', '3 Monhs me Mass Gain Karna 😮', 'a', greyColor.value.toRadixString(16), []));
  //       //
  //       //   _dayBox.putAt(0, WorkoutDay('Day 1', 's', redColor.value.toRadixString(16), []));
  //       //   _dayBox.putAt(1, WorkoutDay('Day 2', 'q', redColor.value.toRadixString(16), []));
  //       //   _dayBox.putAt(2, WorkoutDay('Day 3', 'z', redColor.value.toRadixString(16), []));
  //       //
  //       //   _dayexerciseBox.putAt(0, Exercise('Push-ups_es', 'assets/json/crunch a la poulie pour les obliques.json', null,));
  //       //   _dayexerciseBox.putAt(1, Exercise('Squats_es', 'assets/json/crunch a la poulie pour les obliques.json', null));
  //       //   _dayexerciseBox.putAt(2, Exercise('Pull-ups_es', 'assets/json/crunch a la poulie pour les obliques.json', null));
  //         break;
  //       default:
  //       // Update data for other languages or default
  //       // Update data for Spanish
  //         final routineBox = Hive.box<Routine>('RoutineBox');
  //         final routine1 = Routine('Body weightes', '3 Monhs me Mass Gain Karna 😮', 'e', redColor.value.toRadixString(16), []);
  //         final routine2 = Routine('Full body','3 Monhs me Mass Gain Karna 😮', 'g', blackColor.value.toRadixString(16), []);
  //         final routine3 = Routine('Mass gain','3 Monhs me Mass Gain Karna 😮', 'a', greyColor.value.toRadixString(16), []);
  //         // await routineBox.addAll([routine1, routine2, routine3]);
  //         routineBox.putAt(0, routine1);
  //         routineBox.putAt(1, routine2);
  //         routineBox.putAt(2, routine3);
  //         // Dummy Workout Days
  //         final workoutDaysBox = Hive.box<WorkoutDay>('WorkoutDaysBox');
  //         final workoutDay1 = WorkoutDay('Day 1', 's', redColor.value.toRadixString(16), []);
  //         final workoutDay2 = WorkoutDay('Day 2', 'q', greenColor.value.toRadixString(16), []);
  //         final workoutDay3 = WorkoutDay('Day 3', 'p',greyColor.value.toRadixString(16),[]);
  //         // await workoutDaysBox.addAll([workoutDay1, workoutDay2, workoutDay3]);
  //         workoutDaysBox.putAt(0, workoutDay1);
  //         workoutDaysBox.putAt(1, workoutDay2);
  //         workoutDaysBox.putAt(2, workoutDay3);
  //         // Dummy Exercises
  //         final exercisesBox = Hive.box<Exercise>('ExercisesBox');
  //         final exercise1 = Exercise('Push-upps','assets/json/crunch a la poulie pour les obliques.json',null,);
  //         final exercise2 = Exercise('Squats','assets/json/crunch a la poulie pour les obliques.json',null);
  //         final exercise3 = Exercise('Pull-ups','assets/json/crunch a la poulie pour les obliques.json',null);
  //         // await exercisesBox.addAll([exercise1, exercise2, exercise3]);
  //         exercisesBox.putAt(0, exercise1);
  //         exercisesBox.putAt(1, exercise2);
  //         exercisesBox.putAt(2, exercise3);
  //
  //         // Link routines with workout days
  //
  //         routine1.workoutDays.add(workoutDay1.key);
  //         routine2.workoutDays.add(workoutDay2.key);
  //         routine3.workoutDays.add(workoutDay3.key);
  //         // Link workout days with exercises
  //         workoutDay1.exercises.add(exercise1.key);
  //         workoutDay2.exercises.add(exercise2.key);
  //         workoutDay3.exercises.add(exercise3.key);
  //         // Save changes
  //         await Future.wait([
  //           routine1.save(),
  //           routine2.save(),
  //           routine3.save(),
  //           workoutDay1.save(),
  //           workoutDay2.save(),
  //           workoutDay3.save(),
  //         ]);
  //         break;
  //     }
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Language changed to $_currentLanguage'),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //
  //     setState(() {}); // Manually trigger a rebuild when language changes
  //
  // }


  Future<void> _launchYoutubeVideo(String url) async {
    await launch(url);
  }

  // Future<void> _onRefresh() async {
  //   // await _loadDemoData();
  //   print('rebuild in refresh');
  //   // await _updateDemoData();
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    var routineProvider = Provider.of<RoutineProvider>(context, listen: false);

    routineProvider.loadRoutines();

    final languageProvider =
    Provider.of<LanguageProvider>(context, listen: false);

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
        // title: normalText(title:'Workout Days ${routine.name}'),
        title: normalText(title: languageProvider.translate('app_title'),),
        actions: [

        DropdownButton<String>(
          style: TextStyle(
            color: whiteColor,
          ),
          dropdownColor: Colors.grey,

        value: _currentLanguage,
        items: const [
          DropdownMenuItem(
            value: 'en',
            child: Text('English'),
          ),
          DropdownMenuItem(
            value: 'es',
            child: Text('Spanish'),
          ),
        ],
        onChanged: (value) async {
          languageProvider.changeLanguage(value!);
          setState(() {
            _currentLanguage = value!;
          });
          // await _onRefresh();
        },
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
                title: languageProvider.translate('my_exercise_drawable'),
                ontap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (ctx) => HomeScreen(null)));
                },
              ),
              listTileDrawer(
                assetsvg: 'assets/svg/calnder.svg',
                title: languageProvider.translate('diary_drawable'),
                ontap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (ctx) => ShareScreen()));
                },
              ),

              listTileDrawer(
                assetsvg: 'assets/svg/clock.svg',
                title: languageProvider.translate('timer_drawable'),
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
                title: languageProvider.translate('setting_drawable'),
                ontap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (ctx) => SettingScreen()));
                },
              ),
              listTileDrawer(
                assetsvg: 'assets/svg/facebooklogo.svg',
                title: languageProvider.translate('facebook_draweable'),
                ontap: () async {
                  const facebookProfileUrl = 'https://www.google.com';
                  _launchYoutubeVideo(facebookProfileUrl);
                },
              ),
              listTileDrawer(
                assetsvg: 'assets/svg/sync.svg',
                title: languageProvider.translate('sync_drawable'),
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
                              languageProvider.translate('get_premium_drawable'),
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
                                  color: Color(
                                      int.parse(
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
