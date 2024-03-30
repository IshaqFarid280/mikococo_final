import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mikococo/l10n/AppLocalizations.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/exercide/ExerciseScreenProvider.dart';
import 'package:mikococo/homescreen/HomeScreenProvider.dart';
import 'package:mikococo/l10n/app_localization.dart';
import 'package:mikococo/l10n/languageProvider.dart';
import 'package:mikococo/l10n/localConstants.dart';
import 'package:mikococo/routine/RoutineProvider.dart';
import 'package:mikococo/setting/SettingProvider.dart';
import 'package:mikococo/timer/timer.model.dart';
import 'package:mikococo/workout/WorkoutScreenProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'Gate_way_screen/buttom_navigation_screens.dart';
import 'module/models.dart';
import 'setting/export_provider.dart';
import 'setting/hive_import_export.dart';

void main() async  {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(RoutineAdapter());
  Hive.registerAdapter(WorkoutDayAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(ShoulderModelAdapter());
  Hive.registerAdapter(AbsModelAdapter());
  Hive.registerAdapter(SetsScreenDataAdapter());
  Hive.registerAdapter(TimerValuesAdapter());
  Hive.registerAdapter(TricepsModelAdapter());
  Hive.registerAdapter(BicepsModelAdapter());
  Hive.registerAdapter(ChestModelAdapter());
  Hive.registerAdapter(GlutealModelAdapter());
  // Hive.registerAdapter(SetsScreenDataAdapter());
  await Hive.openBox<ShoulderModel>('shoulder', compactionStrategy: (int total, int deleted) => deleted > 20);
  await Hive.openBox<AbsModel>('abs');
  await Hive.openBox<TricepsModel>('triceps');
  await Hive.openBox<BicepsModel>('biceps');
  await Hive.openBox<ChestModel>('chest');
  await Hive.openBox<GlutealModel>('gluteal');

  await Hive.openBox<Routine>('RoutineBox', compactionStrategy: (int total, int deleted) => deleted > 20);
  await Hive.openBox<WorkoutDay>('WorkoutDaysBox', compactionStrategy: (int total, int deleted) => deleted > 20);
  await Hive.openBox<Exercise>('ExercisesBox', compactionStrategy: (int total, int deleted) => deleted > 20);
  await Hive.openBox<SetsScreenData>('SetsBox');
  await Hive.openBox<TimerValues>('timerValues');
  if (Hive.box<Routine>('RoutineBox').isEmpty || Hive.box<WorkoutDay>('WorkoutDaysBox').isEmpty || Hive.box<Exercise>('ExercisesBox').isEmpty) {
    await initializeDummyData();
  }
  runApp(
      Builder(
        builder: (context){
          return MultiProvider(providers: [
              ChangeNotifierProvider(create: (context) => RoutineProvider()),
          ChangeNotifierProvider(create: (context) => HomeScreenProvider()),
          ChangeNotifierProvider(create: (context) => TimerModel()),
          ChangeNotifierProvider(create: (context) => ExercisesScreenProvider()),
          ChangeNotifierProvider(create: (context) => WorkoutDaysScreenProvider()),
          ChangeNotifierProvider(create: (context) => SwitchProvider()),
          ChangeNotifierProvider(create: (context) => ExportProvider()),
          ChangeNotifierProvider(create: (context) => HiveProvider()),
          ChangeNotifierProvider(create: (context) => LanguageProvider()),
          ],
            child: MyApp(),
          );
        },

        ),
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
  final exercise1 = Exercise('Push-upps','assets/json/crunch a la poulie pour les obliques.json',null,);
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


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _initializeLocale();
  }

  void _initializeLocale() async {
    Locale locale = await LocaleConstants.getLocale();
    setState(() {
      _locale = locale;
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: ( context, languageProvider, child) {
        return MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale?.languageCode == locale?.languageCode &&
                  supportedLocale?.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales?.first;
          },
          locale: _locale,
          supportedLocales: const [
            // Locale('ar', ''),
            Locale('en', ''),
            Locale('es', ''),
            // Locale('ru', ''),
          ],
          // locale: Locale('en'), // Set the default locale
          builder: (context, child) {
            return Directionality(
              textDirection: languageProvider.locale.languageCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: ' ',
            appBarTheme: const AppBarTheme(
              color: blackColor,
              elevation: 0,
            ),
            scaffoldBackgroundColor: backGroundColor,
          ),
          home: const BottomNavigationScreen(),
        );
      }
    );
  }
}
