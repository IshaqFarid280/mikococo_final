import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
   AddPictureScreen({required this.pictures,required this.demo,required this.filteredPictures,required this.filteredDemo});
  @override
  State<AddPictureScreen> createState() => _AddPictureScreenState();
}

class _AddPictureScreenState extends State<AddPictureScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? pickedImagePath;
  String selectedList = 'pictures';

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
      }
      titleController.clear();
      descriptionController.clear();
      setState(() {
        pickedImagePath = null; // Reset the picked image path
      });
      Navigator.push(context, CupertinoPageRoute(builder: (context)=>  HomeScreen(null)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: LeadingIcon(),
        title: normalText(title: 'Globalfit'),
        actions: [

        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              IconButton(
                onPressed: () async {
                  final imagePath = await pickImageFromGallery();
                  if (imagePath != null) {
                    setState(() {
                      pickedImagePath = imagePath;
                    });
                  }
                },
                icon: const Icon(Icons.image),
              ),
              const SizedBox(height: 10,),
              DropdownButton<String>(
                value: selectedList,
                items: ['pictures', 'demo'].map((list) {
                  return DropdownMenuItem<String>(
                    value: list,
                    child: Text(list),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedList = value!;
                  });
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed:(){
                  _addPicture();
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
