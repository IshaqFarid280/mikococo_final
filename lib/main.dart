import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/exercide/ExerciseScreenProvider.dart';
import 'package:mikococo/homescreen/HomeScreenProvider.dart';
import 'package:mikococo/routine/RoutineProvider.dart';
import 'package:mikococo/sets/SetsProvider.dart';
import 'package:mikococo/setting/SettingProvider.dart';
import 'package:mikococo/timer/timer.model.dart';
import 'package:mikococo/workout/WorkoutScreenProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'Gate_way_screen/buttom_navigation_screens.dart';
import 'module/models.dart';

void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(RoutineAdapter());
  Hive.registerAdapter(WorkoutDayAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(AddingPicturesAdapter());
  Hive.registerAdapter(DemonPicturesAdapter());
  Hive.registerAdapter(SetsScreenDataAdapter());
  Hive.registerAdapter(TimerValuesAdapter());
  Hive.registerAdapter(TricepsModelAdapter());
  Hive.registerAdapter(BicepsModelAdapter());
  Hive.registerAdapter(ChestModelAdapter());
  await Hive.openBox<AddingPictures>('Pictures');
  await Hive.openBox<DemonPictures>('Demo');
  await Hive.openBox<TricepsModel>('triceps');
  await Hive.openBox<BicepsModel>('biceps');
  await Hive.openBox<ChestModel>('chest');
  await Hive.openBox<Routine>('RoutineBox', compactionStrategy: (int total, int deleted) => deleted > 20);
  await Hive.openBox<WorkoutDay>('WorkoutDaysBox', compactionStrategy: (int total, int deleted) => deleted > 20);
  await Hive.openBox<Exercise>('ExercisesBox', compactionStrategy: (int total, int deleted) => deleted > 20);
  await Hive.openBox<SetsScreenData>('SetsBox');
  await Hive.openBox<TimerValues>('timerValues');
  if (Hive.box<Routine>('RoutineBox').isEmpty || Hive.box<WorkoutDay>('WorkoutDaysBox').isEmpty || Hive.box<Exercise>('ExercisesBox').isEmpty) {
    await initializeDummyData();
  }
  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => RoutineProvider()),
        ChangeNotifierProvider(create: (context) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (context) => TimerModel()),
        ChangeNotifierProvider(create: (context) => ExercisesScreenProvider()),
        ChangeNotifierProvider(create: (context) => WorkoutDaysScreenProvider()),
        ChangeNotifierProvider(create: (context) => SwitchProvider()),

      ],
        child: MyApp(),
      )
  );

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

Future<void> initializeDummyData() async {
  // Dummy Routines
  final routineBox = Hive.box<Routine>('RoutineBox');
  final routine1 = Routine('Body weight', '3 Monhs me Mass Gain Karna 😮', 'e', redColor.value.toRadixString(16), []);
  final routine2 = Routine('Full body','3 Monhs me Mass Gain Karna 😮', 'g', blackColor.value.toRadixString(16), []);
  final routine3 = Routine('Mass gain','3 Monhs me Mass Gain Karna 😮', 'a', greyColor.value.toRadixString(16), []);
  await routineBox.addAll([routine1, routine2, routine3]);
  // Dummy Workout Days
  final workoutDaysBox = Hive.box<WorkoutDay>('WorkoutDaysBox');
  final workoutDay1 = WorkoutDay('Day 1', 's', redColor.value.toRadixString(16), []);
  final workoutDay2 = WorkoutDay('Day 2', 'q', greenColor.value.toRadixString(16), []);
  final workoutDay3 = WorkoutDay('Day 3', 'p',greyColor.value.toRadixString(16),[]);
  await workoutDaysBox.addAll([workoutDay1, workoutDay2, workoutDay3]);
  // Dummy Exercises
  final exercisesBox = Hive.box<Exercise>('ExercisesBox');
  final exercise1 = Exercise('Push-upps','assets/json/crunch a la poulie pour les obliques.json',null);
  final exercise2 = Exercise('Squats','assets/json/crunch a la poulie pour les obliques.json',null);
  final exercise3 = Exercise('Pull-ups','assets/json/crunch a la poulie pour les obliques.json',null);
  await exercisesBox.addAll([exercise1, exercise2, exercise3]);
  // Link routines with workout days
  routine1.workoutDays.add(workoutDay1.key);
  routine2.workoutDays.add(workoutDay2.key);
  routine3.workoutDays.add(workoutDay3.key);
  // Link workout days with exercises
  workoutDay1.exercises.add(exercise1.key);
  workoutDay2.exercises.add(exercise2.key);
  workoutDay3.exercises.add(exercise3.key);
  // Save changes
  await Future.wait([
    routine1.save(),
    routine2.save(),
    routine3.save(),
    workoutDay1.save(),
    workoutDay2.save(),
    workoutDay3.save(),
  ]);
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // builder: (context, widget) => ResponsiveWrapper.builder(
      //     BouncingScrollWrapper.builder(context, widget!),
      //     maxWidth: 1200,
      //     minWidth: 450,
      //     defaultScale: true,
      //     breakpoints: [
      //       const ResponsiveBreakpoint.resize(550, name: MOBILE),
      //       const ResponsiveBreakpoint.autoScale(800, name: TABLET),
      //       const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
      //       const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
      //       const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
      //     ],
      // ),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: ' ',
        appBarTheme:const  AppBarTheme(


          color:blackColor,
          elevation: 0,
        ),
        scaffoldBackgroundColor: backGroundColor,
      ),
      home:const BottomNavigationScreen(),
    );
  }
}
