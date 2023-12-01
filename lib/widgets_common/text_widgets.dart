import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mikococo/consts/colors.dart';

Widget largeText(
    {title,
    Color color = Colors.white,
    textSize = 20.0,
    FontWeight weight = FontWeight.bold}) {
  return AutoSizeText(
    title,
    style: TextStyle(color: color, fontSize: textSize, fontWeight: weight, fontFamily: "Poppins"),
  );
}

Widget normalText(
    {title,
    Color color = Colors.white,
    textSize = 16.0,
    FontWeight weight = FontWeight.w700}) {
  return AutoSizeText(
    title,
    style: TextStyle(color: color, fontSize: textSize, fontWeight: weight, fontFamily: "Poppins"),
  );
}

Widget smallText(
    {title,
    Color color = Colors.white,
    textSize = 12.0,
    FontWeight weight = FontWeight.w500}) {
  return AutoSizeText(
    title,
    style: TextStyle(color: color, fontSize: textSize, fontWeight: weight, fontFamily: "Poppins"),
  );
}


Widget listTileText(
    {title,
    Color color = whiteColor,
    textSize,
      weight = FontWeight.bold}) {
  return AutoSizeText(
    title,
    style: TextStyle(color: color, fontSize: textSize, fontWeight: weight, fontFamily: "Poppins"),
  );
}

Widget textFormField(
    {required BuildContext context, text, controller, labelText, hint}) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .001,
        ),
        AutoSizeText(
          text,
          style: TextStyle(color: whiteColor, fontSize: 12, fontFamily: "Poppins"),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .01,
        ),
        TextFormField(
          cursorColor: whiteColor,
          controller: controller,
          style: TextStyle(
            color: whiteColor,
              fontFamily: "Poppins"
          ),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
              color: whiteColor,
              fontSize: 14
            ),
            hintText: hint,
            hintStyle: TextStyle(
              color: whiteColor,
              fontSize: 14,
              fontWeight: FontWeight.w100
            ),
            isDense: true,
            fillColor: Colors.transparent,
            filled: true,
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: greyColor, width: 0.0),
            ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: greyColor
                  )
              )
          ),
        ),
      ],
    ),
  );
}

Widget onewordTextFormField({required controller, hint}){
  return
    TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(1),
      ],
      cursorColor: whiteColor,
      controller: controller,
      style: TextStyle(
          color: whiteColor,
          fontFamily: "Poppins"
      ),
      decoration: InputDecoration(

          hintText: hint,
          hintStyle: TextStyle(
              color: whiteColor,
              fontSize: 14,
              fontWeight: FontWeight.w100
          ),
          isDense: true,
          fillColor: Colors.transparent,
          filled: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: greyColor, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: greyColor
              )
          )
      ),
    );
}

class listTileDrawer extends StatelessWidget {
  final VoidCallback ontap;
  final String? title ;
  final String assetsvg ;
  listTileDrawer({required this.ontap, this.title, required this.assetsvg});
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: transparentColor,
        splashColor: transparentColor,
        hoverColor: transparentColor,
      ),
      child: ListTile(
        onTap: ontap,
        leading: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SvgPicture.asset(assetsvg, width: 15, height: 18, color: whiteColor,),
        ),
        title: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text
            (title!,

            style: TextStyle(
              color: whiteColor,
              fontSize: 14,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,

            ),),
        ),
      ),
    );
  }
}

class settingListDrawer extends StatelessWidget {
  final VoidCallback ontap;
  final String? title ;
  final String? subtitle ;
  final String assetsvg ;
  settingListDrawer({required this.ontap, this.title, this.subtitle, required this.assetsvg});
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: transparentColor,
        splashColor: transparentColor,
        hoverColor: transparentColor,
      ),
      child: Column(
        children: [
          ListTile(
            onTap: ontap,
            leading: SvgPicture.asset(assetsvg, width: 15, height: 18, color: whiteColor,),
            subtitle: Text(subtitle!, style: TextStyle(

              color: whiteColor,
              fontSize: 12,
              fontFamily: "Poppins",
              fontWeight: FontWeight.normal,
            ),),
            title: Padding(
              padding: const EdgeInsets.only(left: 2.0, right: 2),
              child: Text
                (title!,

                style: TextStyle(
                  color: whiteColor,
                  fontSize: 14,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,

                ),),
            ),
          ),
        ],
      ),
    );
  }
}


