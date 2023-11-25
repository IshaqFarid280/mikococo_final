import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mikococo/consts/colors.dart';


Widget ourButton({ onpressed, color, textColor, String? title}) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(color),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(12)),
    ),
    onPressed: onpressed,
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
// class AddThingsIcon extends StatelessWidget {
//   final VoidCallback onTap;
//   final String? svgAsset;
//   final Color? fontColor;
//   final Color? backgroundColor;
//   final Color? svgColor;
//
//   AddThingsIcon({
//     required this.onTap,
//     this.svgAsset,
//     this.fontColor,
//     this.backgroundColor,
//     this.svgColor = leadingButton,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(5.0),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(16),
//
//         onTap: onTap,
//         child: Container(
//           padding: EdgeInsets.all(8),
//
//           height: MediaQuery.sizeOf(context).height *0.05,
//           width:MediaQuery.sizeOf(context).width *0.11,
//           decoration: BoxDecoration(
//             color: leadingButton,
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: svgAsset != null
//               ? SvgPicture.asset(
//             svgAsset!,
//             color: svgColor ?? Colors.transparent,
//             height: MediaQuery.of(context).size.height * 0.03,
//             width: MediaQuery.of(context).size.width * 0.07,
//           )
//               : Container(),
//         ),
//       ),
//     );
//   }
// }

