import 'package:hive/hive.dart';
part 'models.g.dart';


@HiveType(typeId: 0)
class Routine extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<int> workoutDays;

  Routine(this.name, this.workoutDays);
}


@HiveType(typeId: 1)
class WorkoutDay extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<int> exercises;

  WorkoutDay(this.name, this.exercises);
}


@HiveType(typeId: 2)
class Exercise extends HiveObject {
  @HiveField(0)
  String name ;

  @HiveField(1)
  String ? image ;


  @HiveField(2)
  List<int> ? sets;

  Exercise(this.name,this.image,this.sets);
}


@HiveType(typeId: 3)
class AddingPictures extends HiveObject {

  @HiveField(0)
  String ? image ;

  @HiveField(1)
  String ? title;

  AddingPictures({this.image,this.title});
}


@HiveType(typeId: 4)
class DemonPictures extends HiveObject {

  @HiveField(0)
  String ? image ;

  @HiveField(1)
  String ? title;

  DemonPictures({this.image,this.title});
}


@HiveType(typeId: 5)
class SetsScreenData extends HiveObject {
  @HiveField(0)
  int reps;

  @HiveField(1)
  double kg;

  @HiveField(2)
  DateTime ? date;

  SetsScreenData(this.reps,this.kg,this.date);
}