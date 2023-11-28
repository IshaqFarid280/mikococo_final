import 'package:flutter/material.dart';
import 'package:mikococo/consts/colors.dart';



class SetsTimerButton extends StatelessWidget {
   SetsTimerButton({required this.onTap,required this.icon});
  final VoidCallback onTap ;
  final IconData icon ;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.05,
        width: MediaQuery.sizeOf(context).width * 0.17,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: buttonColors,
          border: Border.all(color: listTileLeadingColor,style: BorderStyle.solid,strokeAlign: BorderSide.strokeAlignOutside,width: 5),
          // border: Border.all(color: buttonColors,),
        ),
        child:Center(child: Icon(icon,color: whiteColor,size: 30,)) ,
      ),
    );
  }
}
