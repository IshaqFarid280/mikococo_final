import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';


Widget ourButton({ onPressed, color = buttonColors, textColor, String? title}) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(color),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(12)),
    ),
    onPressed: onPressed,
    child: Text(
      title!,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

class LeadingIcon extends StatelessWidget {
  IconData icon ;
   LeadingIcon({this.icon = Icons.arrow_back_ios_new});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: (){
          Navigator.pop(context);
        },
        child: Container(
          height: MediaQuery.sizeOf(context).height *0.01,
          width:MediaQuery.sizeOf(context).width *0.01,
          decoration: BoxDecoration(
            color: leadingButton,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(child: Icon(icon,color:iconColor,),),
        ),
      ),
    );
  }
}

class AddThingsIcon extends StatelessWidget {
  final VoidCallback onTap;
  IconData icon ;
   AddThingsIcon({required this.onTap,this.icon = Icons.add});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap:onTap,
        child: Container(
          height: MediaQuery.sizeOf(context).height *0.1,
          width:MediaQuery.sizeOf(context).width *0.15,
          decoration:const  BoxDecoration(
            color: leadingButton,
            shape: BoxShape.circle,
          ),
          child:Icon(icon,color:iconColor,size:30,),
        ),
      ),
    );
  }
}

class ExercisesNameListTile extends StatelessWidget {
  final String exercisesCategoryName ;
   ExercisesNameListTile({required this.exercisesCategoryName});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: EdgeInsets.only(left: 15,top: 5,bottom: 5),
      leading: Icon(Icons.fitness_center_outlined ,color: Colors.white,),
      title:normalText(title: exercisesCategoryName,textSize:20.0),
      tileColor: goldenColor,
    );
  }
}
