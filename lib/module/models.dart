import 'package:hive/hive.dart';
part 'models.g.dart';


@HiveType(typeId: 0)
class Routine extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  String leadingword;

  @HiveField(3)
  String avatarColor;

  @HiveField(4)
  List<int> workoutDays;

  Routine(this.name,  this.description, this.leadingword, this.avatarColor, this.workoutDays);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'leadingword': leadingword,
      'avatarColor': avatarColor,
      'workoutDays': workoutDays,
    };
  }

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      json['name'],
      json['description'],
      json['leadingword'],
      json['avatarColor'],
      List<int>.from(json['workoutDays']),
    );
  }
}


@HiveType(typeId: 1)
class WorkoutDay extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String leadingword;

  @HiveField(2)
  String avatarColors;

  @HiveField(3)
  List<int> exercises;

  WorkoutDay(this.name, this.leadingword, this.avatarColors,  this.exercises);
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'leadingword': leadingword,
      'avatarColors': avatarColors,
      'exercises': exercises,
    };
  }

  factory WorkoutDay.fromJson(Map<String, dynamic> json) {
    return WorkoutDay(
      json['name'],
      json['leadingword'],
      json['avatarColors'],
      List<int>.from(json['exercises']),
    );
  }

}


@HiveType(typeId: 2)
class Exercise extends HiveObject {
  @HiveField(0)
  String name ;

  @HiveField(1)
  String description ;

  @HiveField(2)
  String ? image ;


  @HiveField(3)
  List<int> ? sets;

  Exercise(this.name, this.description, this.image,this.sets);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'sets': sets,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      json['name'],
      json['description'],
      json['image'],
      List<int>.from(json['sets']),
    );
  }

}


@HiveType(typeId: 3)
class ShoulderModel extends HiveObject {

  @HiveField(0)
  String ? image ;

  @HiveField(1)
  String ? title;

  @HiveField(2)
  String ? description;

  ShoulderModel({this.image,this.title, this.description});
}


@HiveType(typeId: 4)
class AbsModel extends HiveObject {

  @HiveField(0)
  String ? image ;

  @HiveField(1)
  String ? title;


  @HiveField(2)
  String ? description;

  AbsModel({this.image,this.title, this.description});
}


@HiveType(typeId: 5)
class SetsScreenData extends HiveObject {
  @HiveField(0)
  int reps;

  @HiveField(1)
  double kg;

  @HiveField(2)
  DateTime? date;

  @HiveField(3)
  int exerciseKey;

  SetsScreenData(this.reps, this.kg, this.date, this.exerciseKey);

  Map<String, dynamic> toJson() {
    return {
      'reps': reps,
      'kg': kg,
      'date': date?.toIso8601String(),
      'exerciseKey': exerciseKey,
    };
  }

  factory SetsScreenData.fromJson(Map<String, dynamic> json) {
    return SetsScreenData(
      json['reps'],
      json['kg'],
      json['date'] != null ? DateTime.parse(json['date']) : null,
      json['exerciseKey'],
    );
  }
}


@HiveType(typeId:6)
class TimerValues extends HiveObject {
  @HiveField(0)
  List<int> values;

  TimerValues(this.values);
}

@HiveType(typeId: 7)
class TricepsModel extends HiveObject {

  @HiveField(0)
  String ? image ;

  @HiveField(1)
  String ? title;


  @HiveField(2)
  String ? description;

  TricepsModel({this.image,this.title, this.description});
}

@HiveType(typeId: 8)
class BicepsModel extends HiveObject {

  @HiveField(0)
  String ? image ;

  @HiveField(1)
  String ? title;


  @HiveField(2)
  String ? description;

  BicepsModel({this.image,this.title, this.description});
}


@HiveType(typeId: 9)
class ChestModel extends HiveObject {

  @HiveField(0)
  String ? image ;

  @HiveField(1)
  String ? title;


  @HiveField(2)
  String ? description;

  ChestModel({this.image,this.title, this.description});
}

@HiveType(typeId: 10)
class GlutealModel extends HiveObject {

  @HiveField(0)
  String ? image ;

  @HiveField(1)
  String ? title;

  @HiveField(2)
  String ? description;

  GlutealModel({this.image,this.title, this.description});
}




