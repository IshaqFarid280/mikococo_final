import 'package:flutter/material.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';




class ListTileRoutine extends StatelessWidget {
  const ListTileRoutine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 1,
                height:MediaQuery.sizeOf(context).height * 0.1 ,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: listTileColor,
                ),
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left:7),
                        width: MediaQuery.sizeOf(context).width * 0.18,
                        height:MediaQuery.sizeOf(context).height * 0.085,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: listTileLeadingColor,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.1,
                    ),
                    listTileText(title:'Full Body',context: context,textSize:21.0,weight: FontWeight.w700),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
