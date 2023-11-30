import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mikococo/module/models.dart';
import 'package:mikococo/services/Boxes.dart';

class HomeScreenProvider extends ChangeNotifier {
  TextEditingController titleController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? pickedImagePath;
  String selectedList = 'pictures';

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
    final box = BoxesClass.getData();
    final pictureListUserImages = box.values.map((value) =>
        ImageItem(value.image.toString(), value.title.toString(), isAsset: false)).toList();
    // Load user-added images from Hive and append them to the pictures list
    final demoBox = BoxesClass.getDemoData();
    final demoListUserImages = demoBox.values.map((value) =>
        ImageItem(value.image.toString(), value.title.toString(), isAsset: false)).toList();
    // Load user-added images from Hive and append them to the triceps list
    final tricepsBox = BoxesClass.getTricepsData();
    final tricepsListUserImages = tricepsBox.values.map((value) =>
        ImageItem(value.image.toString(), value.title.toString(), isAsset: false)).toList();
    // Load user-added images from Hive and append them to the biceps list
    final bicepsBox = BoxesClass.getBicepsData();
    final bicepsListUserImages = bicepsBox.values.map((value) =>
        ImageItem(value.image.toString(), value.title.toString(), isAsset: false)).toList();
    // Load user-added images from Hive and append them to the chest list
    final chestBox = BoxesClass.getChestData();
    final chestListUserImages = chestBox.values.map((value) =>
        ImageItem(value.image.toString(), value.title.toString(), isAsset: false)).toList();
    // Initialize filteredPictures with the combined list of assets and Hive data
    pictures.addAll(pictureListUserImages);
    pictures.addAll([
      ImageItem('assets/json/crunch.json', 'Goku', isAsset: true),
      ImageItem('assets/images/demon1.gif', 'Vegeta', isAsset: true),
      ImageItem('assets/images/demon2.gif', 'Rengoku', isAsset: true),
      ImageItem('assets/images/goku.gif', 'Tangero', isAsset: true),
      ImageItem('assets/images/vegeta.gif', 'Tomia', isAsset: true),
    ]);
    demo.addAll(demoListUserImages);
    demo.addAll([
      ImageItem('assets/images/demon.gif', 'Goku', isAsset: true),
      ImageItem('assets/images/demon1.gif', 'Vegeta', isAsset: true),
      ImageItem('assets/images/demon2.gif', 'Rengoku', isAsset: true),
      ImageItem('assets/images/goku.gif', 'Tangero', isAsset: true),
      ImageItem('assets/images/vegeta.gif', 'Tomia', isAsset: true),
    ]);
    triceps.addAll(tricepsListUserImages);
    triceps.addAll([
      ImageItem('assets/images/demon.gif', 'Goku', isAsset: true),
      ImageItem('assets/images/demon1.gif', 'Vegeta', isAsset: true),
      ImageItem('assets/images/demon2.gif', 'Rengoku', isAsset: true),
      ImageItem('assets/images/goku.gif', 'Tangero', isAsset: true),
      ImageItem('assets/images/vegeta.gif', 'Tomia', isAsset: true),
    ]);
    biceps.addAll(bicepsListUserImages);
    biceps.addAll([
      ImageItem('assets/images/demon.gif', 'Goku', isAsset: true),
      ImageItem('assets/images/demon1.gif', 'Vegeta', isAsset: true),
      ImageItem('assets/images/demon2.gif', 'Rengoku', isAsset: true),
      ImageItem('assets/images/goku.gif', 'Tangero', isAsset: true),
      ImageItem('assets/images/vegeta.gif', 'Tomia', isAsset: true),
    ]);
    chest.addAll(chestListUserImages);
    chest.addAll([
      ImageItem('assets/images/demon.gif', 'Goku', isAsset: true),
      ImageItem('assets/images/demon1.gif', 'Vegeta', isAsset: true),
      ImageItem('assets/images/demon2.gif', 'Rengoku', isAsset: true),
      ImageItem('assets/images/goku.gif', 'Tangero', isAsset: true),
      ImageItem('assets/images/vegeta.gif', 'Tomia', isAsset: true),
    ]);
    // Initialize filteredPictures with the combined list
    filteredPictures = List.from(pictures);
    // Initialize filteredDemo with the demo list
    filteredDemo = List.from(demo);
    // Initialize filteredDemo with the triceps list
    filteredTriceps = List.from(triceps);
    // Initialize filteredDemo with the triceps list
    filteredBiceps = List.from(biceps);
    // Initialize filteredDemo with the triceps list
    filteredChest = List.from(chest);
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
    pictures.remove(imageItem);
    demo.remove(imageItem);

    // Delete from Hive
    final box = BoxesClass.getData();
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

  void editPicture(int index, String newTitle, String? newImagePath) {
    final box = BoxesClass.getData();
    final pictureToEdit = pictures[index];

    // Check if the picture is from user-added data or asset, and edit accordingly
    if (pictureToEdit.isAsset) {
      pictures[index] = ImageItem(
        pictureToEdit.imagePath,
        newTitle,
        isAsset: true,
      );
      filteredPictures = List.from(pictures);
      notifyListeners();
    } else {
      final updatedPicture = AddingPictures(
        image: newImagePath ?? pictureToEdit.imagePath,
        title: newTitle,
      );
      box.put(pictureToEdit.imagePath, updatedPicture);
      pictures[index] = ImageItem(
        updatedPicture.image!,
        updatedPicture.title!,
        isAsset: false,
      );
      filteredPictures = List.from(pictures);
      notifyListeners();
    }
  }
//

  List<ImageItem> pictures = [];
  List<ImageItem> filteredPictures = [];
  List<ImageItem> demo = [];
  List<ImageItem> filteredDemo = [];
  List<ImageItem> triceps = [];
  List<ImageItem> filteredTriceps = [];
  List<ImageItem> biceps = [];
  List<ImageItem> filteredBiceps = [];
  List<ImageItem> chest = [];
  List<ImageItem> filteredChest = [];

  void filterLists(String searchText) {
    // Keep the logic to filter lists based on the search text.
    filteredPictures = pictures
        .where((image) =>
        image.title.toString().toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    filteredDemo = demo
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
    filteredChest = chest
        .where((image) =>
        image.title.toString().toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    // Notify listeners to trigger UI updates.
    notifyListeners();
  }
}
