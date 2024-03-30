
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';
Widget cateogryExerciseTab(String text, String imageAsset, VoidCallback onTap, BuildContext context) {
  return InkWell(
    onTap: onTap,
    child: Stack(
      children: [
        Opacity(
          opacity: 0.3,
          child: LottieBuilder.asset(
            imageAsset,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.15,
            animate: false, // Animation direction based on isSelected
          ),
        ),
        Center(child: normalText(title: text))
      ],
    ),
  );
}
