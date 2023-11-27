import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            color: leadingBtnColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(child: Icon(icon,color:iconColor,),),
        ),
      ),
    );
  }
}

class trailingbutton extends StatelessWidget {

  final String? svgAsset;
  final Color? svgColor;
  final VoidCallback onTap;

  const trailingbutton({
    super.key, this.svgAsset,  this.svgColor, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),

      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.all(8),

            height: MediaQuery.sizeOf(context).height *0.05,
            width:MediaQuery.sizeOf(context).width *0.11,
            decoration: BoxDecoration(
              // color: leadingButton,
              color: svgColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child:  svgAsset != null
                ? SvgPicture.asset(svgAsset! )
                : Icon(Icons.error), // Replace with your placeholder or handle it differently

        ),
      ),
    );
  }
}
class AddThingsIcon extends StatelessWidget {
  final VoidCallback onTap;
  final String? svgAsset;
  final Color? fontColor;
  final Color? backgroundColor;
  final Color? svgColor;

  AddThingsIcon({
    required this.onTap,
    this.svgAsset,
    this.fontColor,
    this.backgroundColor,
    this.svgColor = leadingBtnColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(8),

          height: MediaQuery.sizeOf(context).height *0.05,
          width:MediaQuery.sizeOf(context).width *0.11,
          decoration: BoxDecoration(
            color: leadingBtnColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: svgAsset != null
              ? SvgPicture.asset(
            svgAsset!,
            color: svgColor ?? Colors.transparent,
            height: MediaQuery.of(context).size.height * 0.03,
            width: MediaQuery.of(context).size.width * 0.07,
          )
              : Container(),
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


class SubmitButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? titlee;
  final Color? primaryColor;

  const SubmitButton({super.key, required this.onTap,  this.titlee,  this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(4),
      width: MediaQuery.of(context).size.width*1,
      height: MediaQuery.of(context).size.height*0.08,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20)
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(

            primary: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            )
        ),
        child: AutoSizeText(titlee!, style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w800
        ),),
      ),
    );
  }
}

class HomeScreenAddExerciseButton extends StatelessWidget {
   HomeScreenAddExerciseButton({required this.onTap});

   final VoidCallback onTap ;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        margin:const  EdgeInsets.only(right:5),
        height: MediaQuery.sizeOf(context).height * 0.07,
        width: MediaQuery.sizeOf(context).width * 0.16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: listTileLeadingColor,
        ),
        child:const Center(child: Icon(Icons.data_saver_on_outlined ,color:goldenColor,size:30 ,)),
// Icons.loupe_outlined
// Icons.data_saver_on_outlined
      ),
    );
  }
}

