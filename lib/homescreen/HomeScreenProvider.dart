import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mikococo/module/models.dart';
import 'package:mikococo/services/Boxes.dart';
import 'package:flutter_gen/gen_l10n/mikococo_final.dart';

class HomeScreenProvider extends ChangeNotifier {
  TextEditingController titleController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? pickedImagePath;
  String selectedList = 'Chest';

  Future<String?> pickImageFromGallery() async {
    // Keep this method as it is, as it's related to the UI interaction.
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile.path;
    }
    return null;
  }

  HomeScreenProvider() {
    // Load user-added images from Hive and append them to the pictures list
    final shoulderBox = BoxesClass.getshoulder();
    final shoulderListUserImages = shoulderBox.values.map((value) =>
        ImageItem(value.image.toString(), value.title.toString(), value.description.toString(), isAsset: false)).toList();
    // Load user-added images from Hive and append them to the pictures list
    final absBox = BoxesClass.getabs();
    final absListUserImages = absBox.values.map((value) =>
        ImageItem(value.image.toString(), value.title.toString(), value.description.toString(),  isAsset: false)).toList();
    // Load user-added images from Hive and append them to the triceps list
    final tricepsBox = BoxesClass.getTricepsData();
    final tricepsListUserImages = tricepsBox.values.map((value) =>
        ImageItem(value.image.toString(), value.title.toString(), value.description.toString(), isAsset: false)).toList();
    // Load user-added images from Hive and append them to the biceps list
    final bicepsBox = BoxesClass.getBicepsData();
    final bicepsListUserImages = bicepsBox.values.map((value) =>
        ImageItem(value.image.toString(), value.title.toString(), value.description.toString(), isAsset: false)).toList();
    // Load user-added images from Hive and append them to the chest list
    final chestBox = BoxesClass.getChestData();
    final chestListUserImages = chestBox.values.map((value) =>
        ImageItem(value.image.toString(), value.title.toString(), value.description.toString(), isAsset: false)).toList();
    // Initialize filteredPictures with the combined list of assets and Hive data

    final glutealBoxBox = BoxesClass.getglutealData();
    final glutealListUserImages = glutealBoxBox.values.map((value) =>
        ImageItem(value.image.toString(), value.title.toString(), value.description.toString(), isAsset: false)).toList();
    // Initialize filteredPictures with the combined list of assets and Hive data


    chest.addAll(chestListUserImages);
    chest.addAll([
      ImageItem('assets/json/crunch a la poulie pour les obliques.json', '11Pulley Crunch For Obliques', 'The kneeling cable oblique crunch is an effective exercise for working the obliques with constant resistance. It helps develop a toned and strong waist, while improving core stability and posture. The advantage of this exercise is that you can change the weights quickly and therefore do pyramid series by gradually increasing the load.', isAsset: true, ),
      ImageItem('assets/json/crunch poulie haute exercice musculation.json', 'Crunch High Pulley Exercise Bodybuilding', "While there's nothing inherently wrong with doing a weighted crunch, holding a disc across your chest or behind your head can be uncomfortable and cumbersome. And the more strength you gain, the more difficult it will be to add weight without risking crushing your ribcage or putting strain on your neck.\nHere's why it's time to move on to the cable kneeling crunch. Using a machine equipped with a pulley allows you to add weight using a pin, and the constant tension of the cable means your abdominal muscles have to work hard at every moment during the exercise, making this exercise more effective than the classic crunch.", isAsset: true),
      ImageItem('assets/json/flexions laterales poulie basse.json', 'lateral Flexions Low Pulley', "Low pulley side bends are simply a variation of the side bend typically performed with dumbbells. This exercise is commonly used to develop the oblique muscles of the abdominal girdle. \nStrengthening the obliques has several benefits, including improved mobility, reduced risk of injury, improved physical performance, improved stability and improved posture. \nNamely, whichever hand you hold the handle with, the opposite side is used. For example, if you hold the handle in your left hand, the right side is worked and vice versa.", isAsset: true),
      ImageItem('assets/json/rotation buste debout poulie.json', 'Rotation Bust Standing Pulley',"Empty", isAsset: true),
      ImageItem('assets/json/rotation buste elastique pallof press.json', 'Rotation Elastic Bust Pallof Press', "empty", isAsset: true),
      ImageItem('assets/json/russian twist poulie.json', 'Russian Twist Pulley', "This variation of Russian twists will be the centerpiece of your training program to strengthen your abs!\nRussian pulley rotations (on a Swiss ball) are a unique exercise that you won't often see practiced in your gym. Maybe you've never even done it yourself. However, it has advantages and is an excellent variation for working the obliques.\nAnd since it is a functional exercise, it will help you perform better overall in any sporting activity.", isAsset: true),
    ]);




    biceps.addAll(bicepsListUserImages);
    biceps.addAll([
      ImageItem('assets/json/crunch a la poulie pour les obliques.json', '22Pulley Crunch For Obliques', 'The kneeling cable oblique crunch is an effective exercise for working the obliques with constant resistance. It helps develop a toned and strong waist, while improving core stability and posture. The advantage of this exercise is that you can change the weights quickly and therefore do pyramid series by gradually increasing the load.', isAsset: true, ),
      ImageItem('assets/json/crunch poulie haute exercice musculation.json', 'Crunch High Pulley Exercise Bodybuilding', "While there's nothing inherently wrong with doing a weighted crunch, holding a disc across your chest or behind your head can be uncomfortable and cumbersome. And the more strength you gain, the more difficult it will be to add weight without risking crushing your ribcage or putting strain on your neck.\nHere's why it's time to move on to the cable kneeling crunch. Using a machine equipped with a pulley allows you to add weight using a pin, and the constant tension of the cable means your abdominal muscles have to work hard at every moment during the exercise, making this exercise more effective than the classic crunch.", isAsset: true),
      ImageItem('assets/json/flexions laterales poulie basse.json', 'lateral Flexions Low Pulley', "Low pulley side bends are simply a variation of the side bend typically performed with dumbbells. This exercise is commonly used to develop the oblique muscles of the abdominal girdle. \nStrengthening the obliques has several benefits, including improved mobility, reduced risk of injury, improved physical performance, improved stability and improved posture. \nNamely, whichever hand you hold the handle with, the opposite side is used. For example, if you hold the handle in your left hand, the right side is worked and vice versa.", isAsset: true),
      ImageItem('assets/json/rotation buste debout poulie.json', 'Rotation Bust Standing Pulley',"Empty", isAsset: true),
      ImageItem('assets/json/rotation buste elastique pallof press.json', 'Rotation Elastic Bust Pallof Press', "empty", isAsset: true),
      ImageItem('assets/json/russian twist poulie.json', 'Russian Twist Pulley', "This variation of Russian twists will be the centerpiece of your training program to strengthen your abs!\nRussian pulley rotations (on a Swiss ball) are a unique exercise that you won't often see practiced in your gym. Maybe you've never even done it yourself. However, it has advantages and is an excellent variation for working the obliques.\nAnd since it is a functional exercise, it will help you perform better overall in any sporting activity.", isAsset: true),
    ]);
    triceps.addAll(tricepsListUserImages);
    triceps.addAll([
      ImageItem('assets/json/crunch a la poulie pour les obliques.json', '33Pulley Crunch For Obliques', 'The kneeling cable oblique crunch is an effective exercise for working the obliques with constant resistance. It helps develop a toned and strong waist, while improving core stability and posture. The advantage of this exercise is that you can change the weights quickly and therefore do pyramid series by gradually increasing the load.', isAsset: true, ),
      ImageItem('assets/json/crunch poulie haute exercice musculation.json', 'Crunch High Pulley Exercise Bodybuilding', "While there's nothing inherently wrong with doing a weighted crunch, holding a disc across your chest or behind your head can be uncomfortable and cumbersome. And the more strength you gain, the more difficult it will be to add weight without risking crushing your ribcage or putting strain on your neck.\nHere's why it's time to move on to the cable kneeling crunch. Using a machine equipped with a pulley allows you to add weight using a pin, and the constant tension of the cable means your abdominal muscles have to work hard at every moment during the exercise, making this exercise more effective than the classic crunch.", isAsset: true),
      ImageItem('assets/json/flexions laterales poulie basse.json', 'lateral Flexions Low Pulley', "Low pulley side bends are simply a variation of the side bend typically performed with dumbbells. This exercise is commonly used to develop the oblique muscles of the abdominal girdle. \nStrengthening the obliques has several benefits, including improved mobility, reduced risk of injury, improved physical performance, improved stability and improved posture. \nNamely, whichever hand you hold the handle with, the opposite side is used. For example, if you hold the handle in your left hand, the right side is worked and vice versa.", isAsset: true),
      ImageItem('assets/json/rotation buste debout poulie.json', 'Rotation Bust Standing Pulley',"Empty", isAsset: true),
      ImageItem('assets/json/rotation buste elastique pallof press.json', 'Rotation Elastic Bust Pallof Press', "empty", isAsset: true),
      ImageItem('assets/json/russian twist poulie.json', 'Russian Twist Pulley', "This variation of Russian twists will be the centerpiece of your training program to strengthen your abs!\nRussian pulley rotations (on a Swiss ball) are a unique exercise that you won't often see practiced in your gym. Maybe you've never even done it yourself. However, it has advantages and is an excellent variation for working the obliques.\nAnd since it is a functional exercise, it will help you perform better overall in any sporting activity.", isAsset: true),
    ]);

    abs.addAll(absListUserImages);
    abs.addAll([
      ImageItem('assets/json/crunch a la poulie pour les obliques.json', '44Pulley Crunch For Obliques', 'The kneeling cable oblique crunch is an effective exercise for working the obliques with constant resistance. It helps develop a toned and strong waist, while improving core stability and posture. The advantage of this exercise is that you can change the weights quickly and therefore do pyramid series by gradually increasing the load.', isAsset: true, ),
      ImageItem('assets/json/crunch poulie haute exercice musculation.json', 'Crunch High Pulley Exercise Bodybuilding', "While there's nothing inherently wrong with doing a weighted crunch, holding a disc across your chest or behind your head can be uncomfortable and cumbersome. And the more strength you gain, the more difficult it will be to add weight without risking crushing your ribcage or putting strain on your neck.\nHere's why it's time to move on to the cable kneeling crunch. Using a machine equipped with a pulley allows you to add weight using a pin, and the constant tension of the cable means your abdominal muscles have to work hard at every moment during the exercise, making this exercise more effective than the classic crunch.", isAsset: true),
      ImageItem('assets/json/flexions laterales poulie basse.json', 'lateral Flexions Low Pulley', "Low pulley side bends are simply a variation of the side bend typically performed with dumbbells. This exercise is commonly used to develop the oblique muscles of the abdominal girdle. \nStrengthening the obliques has several benefits, including improved mobility, reduced risk of injury, improved physical performance, improved stability and improved posture. \nNamely, whichever hand you hold the handle with, the opposite side is used. For example, if you hold the handle in your left hand, the right side is worked and vice versa.", isAsset: true),
      ImageItem('assets/json/rotation buste debout poulie.json', 'Rotation Bust Standing Pulley',"Empty", isAsset: true),
      ImageItem('assets/json/rotation buste elastique pallof press.json', 'Rotation Elastic Bust Pallof Press', "empty", isAsset: true),
      ImageItem('assets/json/russian twist poulie.json', 'Russian Twist Pulley', "This variation of Russian twists will be the centerpiece of your training program to strengthen your abs!\nRussian pulley rotations (on a Swiss ball) are a unique exercise that you won't often see practiced in your gym. Maybe you've never even done it yourself. However, it has advantages and is an excellent variation for working the obliques.\nAnd since it is a functional exercise, it will help you perform better overall in any sporting activity.", isAsset: true),
    ]);


    gluteal.addAll(glutealListUserImages);
    gluteal.addAll([
      ImageItem('assets/json/crunch a la poulie pour les obliques.json', '55Pulley Crunch For Obliques', 'The kneeling cable oblique crunch is an effective exercise for working the obliques with constant resistance. It helps develop a toned and strong waist, while improving core stability and posture. The advantage of this exercise is that you can change the weights quickly and therefore do pyramid series by gradually increasing the load.', isAsset: true, ),
      ImageItem('assets/json/crunch poulie haute exercice musculation.json', 'Crunch High Pulley Exercise Bodybuilding', "While there's nothing inherently wrong with doing a weighted crunch, holding a disc across your chest or behind your head can be uncomfortable and cumbersome. And the more strength you gain, the more difficult it will be to add weight without risking crushing your ribcage or putting strain on your neck.\nHere's why it's time to move on to the cable kneeling crunch. Using a machine equipped with a pulley allows you to add weight using a pin, and the constant tension of the cable means your abdominal muscles have to work hard at every moment during the exercise, making this exercise more effective than the classic crunch.", isAsset: true),
      ImageItem('assets/json/flexions laterales poulie basse.json', 'lateral Flexions Low Pulley', "Low pulley side bends are simply a variation of the side bend typically performed with dumbbells. This exercise is commonly used to develop the oblique muscles of the abdominal girdle. \nStrengthening the obliques has several benefits, including improved mobility, reduced risk of injury, improved physical performance, improved stability and improved posture. \nNamely, whichever hand you hold the handle with, the opposite side is used. For example, if you hold the handle in your left hand, the right side is worked and vice versa.", isAsset: true),
      ImageItem('assets/json/rotation buste debout poulie.json', 'Rotation Bust Standing Pulley',"Empty", isAsset: true),
      ImageItem('assets/json/rotation buste elastique pallof press.json', 'Rotation Elastic Bust Pallof Press', "empty", isAsset: true),
      ImageItem('assets/json/russian twist poulie.json', 'Russian Twist Pulley', "This variation of Russian twists will be the centerpiece of your training program to strengthen your abs!\nRussian pulley rotations (on a Swiss ball) are a unique exercise that you won't often see practiced in your gym. Maybe you've never even done it yourself. However, it has advantages and is an excellent variation for working the obliques.\nAnd since it is a functional exercise, it will help you perform better overall in any sporting activity.", isAsset: true),
    ]);

    shoulder.addAll(shoulderListUserImages);
    shoulder.addAll([
      ImageItem('assets/json/crunch a la poulie pour les obliques.json', '66Pulley Crunch For Obliques', 'The kneeling cable oblique crunch is an effective exercise for working the obliques with constant resistance. It helps develop a toned and strong waist, while improving core stability and posture. The advantage of this exercise is that you can change the weights quickly and therefore do pyramid series by gradually increasing the load.', isAsset: true, ),
      ImageItem('assets/json/crunch poulie haute exercice musculation.json', 'Crunch High Pulley Exercise Bodybuilding', "While there's nothing inherently wrong with doing a weighted crunch, holding a disc across your chest or behind your head can be uncomfortable and cumbersome. And the more strength you gain, the more difficult it will be to add weight without risking crushing your ribcage or putting strain on your neck.\nHere's why it's time to move on to the cable kneeling crunch. Using a machine equipped with a pulley allows you to add weight using a pin, and the constant tension of the cable means your abdominal muscles have to work hard at every moment during the exercise, making this exercise more effective than the classic crunch.", isAsset: true),
      ImageItem('assets/json/flexions laterales poulie basse.json', 'lateral Flexions Low Pulley', "Low pulley side bends are simply a variation of the side bend typically performed with dumbbells. This exercise is commonly used to develop the oblique muscles of the abdominal girdle. \nStrengthening the obliques has several benefits, including improved mobility, reduced risk of injury, improved physical performance, improved stability and improved posture. \nNamely, whichever hand you hold the handle with, the opposite side is used. For example, if you hold the handle in your left hand, the right side is worked and vice versa.", isAsset: true),
      ImageItem('assets/json/rotation buste debout poulie.json', 'Rotation Bust Standing Pulley',"Empty", isAsset: true),
      ImageItem('assets/json/rotation buste elastique pallof press.json', 'Rotation Elastic Bust Pallof Press', "empty", isAsset: true),
      ImageItem('assets/json/russian twist poulie.json', 'Russian Twist Pulley', "This variation of Russian twists will be the centerpiece of your training program to strengthen your abs!\nRussian pulley rotations (on a Swiss ball) are a unique exercise that you won't often see practiced in your gym. Maybe you've never even done it yourself. However, it has advantages and is an excellent variation for working the obliques.\nAnd since it is a functional exercise, it will help you perform better overall in any sporting activity.", isAsset: true),
      // ImageItem('assets/images/', '', isAsset: true),

    ]);


    // Initialize filteredPictures with the combined list
    // Initialize filteredDemo with the chest list
    filteredChest = List.from(chest);
    // Initialize filteredDemo with the biceps list
    filteredBiceps = List.from(biceps);
    // Initialize filteredDemo with the triceps list
    filteredTriceps = List.from(triceps);
    // Initialize filteredDemo with the abs list
    filteredabs = List.from(abs);
    // Initialize filteredDemo with the gluteal list
    filteredGluteal = List.from(gluteal);
    // Initialize filteredDemo with the shoulder list
    filteredshoulder = List.from(shoulder);


  }

  void addExercise(String name, String imagePath, WorkoutDay workoutDay) {
    final exercise = Exercise(name, imagePath, null);
    Hive.box<Exercise>('ExercisesBox').add(exercise).then((exerciseKey) {
      workoutDay.exercises.add(exerciseKey);
      workoutDay.save();
    });
  }

  void addExerciseToWorkout(Exercise exercise) {
    // You might not need this method if you're not modifying widget state directly.
    // If you need to modify the widget state, consider using a StateNotifierProvider.

  }
//
  void deleteImageItem(ImageItem imageItem) {
    // Delete from UI
    shoulder.remove(imageItem);
    abs.remove(imageItem);

    // Delete from Hive
    final box = BoxesClass.getshoulder();
    box.values
        .where((value) =>
    value.image == imageItem.imagePath && value.title == imageItem.title)
        .forEach((value) => value.delete());

    // Notify listeners that the data has changed
    notifyListeners();
  }


  Future<String?> pickNewImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile?.path;
  }


  List<ImageItem> chest = [];
  List<ImageItem> filteredChest = [];

  List<ImageItem> biceps = [];
  List<ImageItem> filteredBiceps = [];
  List<ImageItem> triceps = [];
  List<ImageItem> filteredTriceps = [];

  List<ImageItem> abs = [];
  List<ImageItem> filteredabs = [];
  List<ImageItem> gluteal = [];
  List<ImageItem> filteredGluteal = [];

  List<ImageItem> shoulder = [];
  List<ImageItem> filteredshoulder = [];

  void filterLists(String searchText) {
    // Keep the logic to filter lists based on the search text.
    filteredshoulder = shoulder
        .where((image) =>
        image.title.toString().toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    filteredabs = abs
        .where((image) =>
        image.title.toString().toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    filteredTriceps = triceps
        .where((image) =>
        image.title.toString().toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    filteredBiceps = biceps
        .where((image) =>
        image.title.toString().toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    filteredGluteal = gluteal
        .where((image) =>
        image.title.toString().toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    filteredChest = chest
        .where((image) =>
        image.title.toString().toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    // Notify listeners to trigger UI updates.
    notifyListeners();
  }
}
