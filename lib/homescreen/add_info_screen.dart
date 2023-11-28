import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';

import '../module/models.dart';
import '../services/Boxes.dart';
import '../widgets_common/our_button.dart';
import 'home_screen.dart';

class AddPictureScreen extends StatefulWidget {
  final List<ImageItem> pictures;
  final List<ImageItem> filteredPictures;
  final List<ImageItem> demo;
  final List<ImageItem> filteredDemo;
  final List<ImageItem> triceps;
  final List<ImageItem> filteredTriceps;
  final List<ImageItem> biceps;
  final List<ImageItem> filteredBiceps;
  final List<ImageItem> chest;
  final List<ImageItem> filteredChest;
  AddPictureScreen(
      {required this.pictures,
      required this.demo,
      required this.filteredPictures,
      required this.filteredDemo,
      required this.triceps,
      required this.biceps,
      required this.chest,
      required this.filteredChest,
      required this.filteredBiceps,
      required this.filteredTriceps});
  @override
  State<AddPictureScreen> createState() => _AddPictureScreenState();
}

class _AddPictureScreenState extends State<AddPictureScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? pickedImagePath;
  // String selectedList = 'pictures';
  String? selectedList;
  String? dummyselectedList;

  Future<String?> pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile.path;
    }
    return null;
  }

  _addPicture() {
    if (pickedImagePath != null) {
      if (selectedList == 'pictures') {
        var data = AddingPictures(
          image: pickedImagePath!,
          title: titleController.text.toString(),
        );
        final box = BoxesClass.getData();
        box.add(data);
        data.save();
        setState(() {
          widget.pictures.add(ImageItem(
            pickedImagePath!,
            titleController.text.toString(),
            isAsset: false,
          ));
          widget.filteredPictures.add(ImageItem(
            pickedImagePath!,
            titleController.text.toString(),
            isAsset: false,
          ));
        });
      } else if (selectedList == 'demo') {
        var data = DemonPictures(
          image: pickedImagePath!,
          title: titleController.text.toString(),
        );
        final box = BoxesClass.getDemoData();
        box.add(data);
        data.save();
        setState(() {
          widget.demo.add(ImageItem(
            pickedImagePath!,
            titleController.text.toString(),
            isAsset: false,
          ));
          widget.filteredDemo.add(ImageItem(
            pickedImagePath!,
            titleController.text.toString(),
            isAsset: false,
          ));
        });
      }   else if  (selectedList == 'Triceps') {
        var data = TricepsModel(
          image: pickedImagePath!,
          title: titleController.text.toString(),
        );
        final box = BoxesClass.getTricepsData();
        box.add(data);
        data.save();
        setState(() {
          widget.triceps.add(ImageItem(
            pickedImagePath!,
            titleController.text.toString(),
            isAsset: false,
          ));
          widget.filteredTriceps.add(ImageItem(
            pickedImagePath!,
            titleController.text.toString(),
            isAsset: false,
          ));
        });
      }  else if  (selectedList == 'Biceps') {
        var data = BicepsModel(
          image: pickedImagePath!,
          title: titleController.text.toString(),
        );
        final box = BoxesClass.getBicepsData();
        box.add(data);
        data.save();
        setState(() {
          widget.biceps.add(ImageItem(
            pickedImagePath!,
            titleController.text.toString(),
            isAsset: false,
          ));
          widget.filteredBiceps.add(ImageItem(
            pickedImagePath!,
            titleController.text.toString(),
            isAsset: false,
          ));
        });
      }  else if  (selectedList == 'Chest') {
        var data = ChestModel(
          image: pickedImagePath!,
          title: titleController.text.toString(),
        );
        final box = BoxesClass.getChestData();
        box.add(data);
        data.save();
        setState(() {
          widget.chest.add(ImageItem(
            pickedImagePath!,
            titleController.text.toString(),
            isAsset: false,
          ));
          widget.filteredChest.add(ImageItem(
            pickedImagePath!,
            titleController.text.toString(),
            isAsset: false,
          ));
        });
      }
      titleController.clear();
      descriptionController.clear();
      setState(() {
        pickedImagePath = null; // Reset the picked image path
      });
      Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: (context) => HomeScreen(null)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: LeadingIcon(),
        title: normalText(title: 'Globalfit'),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.28,
                  height: MediaQuery.of(context).size.height * 0.13,
                  child: pickedImagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(pickedImagePath!),
                            fit: BoxFit.fitWidth,
                            height: MediaQuery.of(context).size.height * 0.13,
                            width: MediaQuery.of(context).size.width * 0.28,
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.image,
                            color: whiteColor,
                            size: MediaQuery.of(context).size.width * 0.28,
                          ),
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () async {
                      final imagePath = await pickImageFromGallery();
                      if (imagePath != null) {
                        setState(() {
                          pickedImagePath = imagePath;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.edit,
                        size: 18,
                        color: goldenColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: greyColor)),
                  child: Center(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        highlightColor: transparentColor,
                        splashColor: transparentColor,
                        hoverColor: transparentColor,
                      ),
                      child: DropdownButton<String>(
                        borderRadius: BorderRadius.circular(10),
                        dropdownColor: leadingBtnColor,
                        padding: EdgeInsets.only(left: 16, right: 16),
                        isExpanded: true,

                        value: selectedList,
                        icon: Icon(Icons.arrow_drop_down, color: whiteColor),
                        iconEnabledColor: whiteColor,
                        underline: Container(), // or underline: SizedBox(),
                        hint: Text(
                          '--Select--',
                          style: TextStyle(color: whiteColor),
                        ),
                        style: TextStyle(color: whiteColor),
                        items: [
                          //null, //represents the initial state
                          'pictures','demo','Triceps','Biceps','Chest',
                        ]
                            .map((list) {
                              return DropdownMenuItem<String>(
                                alignment: Alignment.center,
                                value: list,
                                child: Text(
                                  list,
                                  style: TextStyle(color: whiteColor),
                                ),
                              );
                            })
                            .where((item) => item.value != null)
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedList = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: greyColor)),
                  child: Center(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        highlightColor: transparentColor,
                        splashColor: transparentColor,
                        hoverColor: transparentColor,
                      ),
                      child: DropdownButton<String>(
                        borderRadius: BorderRadius.circular(10),
                        dropdownColor: leadingBtnColor,
                        padding: EdgeInsets.only(left: 16, right: 16),

                        value: dummyselectedList,
                        icon: Icon(Icons.arrow_drop_down, color: whiteColor),
                        iconEnabledColor: whiteColor,
                        underline: Container(), // or underline: SizedBox(),
                        hint: Text(
                          '--Select--',
                          style: TextStyle(color: whiteColor),
                        ),
                        isExpanded: true,
                        style: TextStyle(color: whiteColor),
                        items: [
                          //null, //represents the initial state
                          'Weight & Reps', 'Time'
                        ]
                            .map((list) {
                              return DropdownMenuItem<String>(
                                alignment: Alignment.center,
                                value: list,
                                child: Text(
                                  list,
                                  style: TextStyle(color: whiteColor),
                                ),
                              );
                            })
                            .where((item) => item.value != null)
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            dummyselectedList = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            textFormField(
              context: context,
              text: 'Exercise Name',
              controller: titleController,
              hint: 'exercise name',
              // labelText: 'Example - Mass Gain Program'
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            textFormField(
              context: context,
              text: 'Description',
              controller: descriptionController,
              hint: 'description',
              // labelText: 'Example - Mass Gain Program'
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Spacer(),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: SubmitButton(
                    onTap: () {
                      _addPicture();
                    },
                    titlee: 'Add',
                    primaryColor: goldenColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
