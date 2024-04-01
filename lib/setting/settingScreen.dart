import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/l10n/languageProvider.dart';
import 'package:mikococo/setting/SettingProvider.dart';
import 'package:mikococo/setting/SoundModel.dart';
import 'package:mikococo/setting/export_screen.dart';
import 'package:mikococo/setting/motionToastConstructor.dart';
import 'package:mikococo/widgets_common/our_button.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'importing _exporting.dart';


class SettingScreen extends StatelessWidget {

  Future<void> _launchYoutubeVideo(String url) async {
  await launch(url);
}

  _openMap() async {
    const url =  "https://play.google.com/store/apps/details?id=" + "com.example.kids";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _Share() async{
    // FlutterShare.share(title: 'SHare',linkUrl: "https://play.google.com/store/apps/details?id=" + "com.example.kids");

    Share.share('Check out this awesome app!', subject: "https://play.google.com/store/apps/details?id=" + "com.example.kids");
  }

  void _showUnitSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData(
          canvasColor: leadingBtnColor,
        ),
          child: AlertDialog(
            backgroundColor: leadingBtnColor,
            title: largeText(title: 'Select Weight Unit'),
            content: Container(
              height: MediaQuery.of(context).size.height*0.15,
              child: Column(
                children: [
                  RadioListTile<String>(
                    activeColor: goldenColor,
                    title: normalText(title: 'Kg'
                    ),
                    value: 'kg',
                    groupValue: Provider.of<SwitchProvider>(context).selectedUnit,
                    onChanged: (value) {
                      Provider.of<SwitchProvider>(context, listen: false).setSelectedUnit(value!);
                    },
                  ),
                  RadioListTile<String>(
                    activeColor: goldenColor,
                    title: normalText(title: 'lbs'
                    ),
                    value: 'lbs',
                    groupValue: Provider.of<SwitchProvider>(context).selectedUnit,
                    onChanged: (value) {
                      Provider.of<SwitchProvider>(context, listen: false).setSelectedUnit(value!);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              // SubmitButtonnoPadding(onTap: (){
              //   Navigator.of(context).pop();
              // }, titlee: 'Ok', primaryColor: goldenColor),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: iconColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        )
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: normalText(title: 'Cancel'),
                  ),

                  ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      primary: goldenColor,
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    )
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Handle the save logic here if needed
                    },
                    child: normalText(title: 'Save'),
                  ),
                ],
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            titlePadding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            contentPadding: EdgeInsets.symmetric(horizontal: 25),
            actionsPadding: EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 20),
            actionsAlignment: MainAxisAlignment.center,
            clipBehavior: Clip.antiAliasWithSaveLayer,
          ),
        );
      },
    );
  }

  void _showSoundSelectionDialog(BuildContext context) {
    SwitchProvider switchProvider = Provider.of<SwitchProvider>(context, listen: false);
    int selectedTileIndex = switchProvider.sounds.indexWhere((sound) =>
    switchProvider.selectedSound?.name == sound.name);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            canvasColor: leadingBtnColor,
          ),
          child: AlertDialog(
            backgroundColor: leadingBtnColor,
            title: largeText(title: 'Select Sound', color: whiteColor),
            content: Container(
              height: MediaQuery.of(context).size.height*0.45,
              child: Column(
                children: switchProvider.sounds.asMap().entries.map((entry) {
                  int index = entry.key;
                  SoundModel sound = entry.value;

                  return RadioListTile<String>(
                    toggleable: true,
                    activeColor: goldenColor,
                    title: Text(sound.name, style: TextStyle(
                      color: whiteColor,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold
                    ),),
                    value: sound.name,
                    groupValue: switchProvider.selectedSound?.name,
                    onChanged: (value) {
                      switchProvider.setSelectedSound(sound);
                      switchProvider.playSound(sound); // Play the selected sound
                      // Navigator.of(context).pop();

                      // Update the selected tile index
                      switchProvider.setSelectedTileIndex(index);
                    },
                    selected: switchProvider.selectedTileIndex == index,
                    // controlAffinity: ListTileControlAffinity.trailing,
                  );
                }).toList(),
              ),
            ),
            actions: [
              // SubmitButtonnoPadding(onTap: (){
              //   Navigator.of(context).pop();
              // }, titlee: 'Ok', primaryColor: goldenColor),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: iconColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        )
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: normalText(title: 'Cancel', textSize: 12.0),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: goldenColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        )
                    ),
                    onPressed: () {
                      CustomMotionToast.showSuccessToast(context, "This option is only included in", "premium Version");
                    },
                    child: normalText(title: 'Save', textSize: 12.0),
                  ),
                ],
              ),
            ],

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            titlePadding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            contentPadding: EdgeInsets.symmetric(horizontal: 25),
            actionsPadding: EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 20),
            actionsAlignment: MainAxisAlignment.center,
            clipBehavior: Clip.antiAliasWithSaveLayer,
          ),
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: LeadingIcon(),
        title: normalText(title: languageProvider.translate('app_title')),
        centerTitle: true,
      ),
      body: Consumer<SwitchProvider>(
        builder: (context, switchProvider, _) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 4.0, right: 8, top: 12, bottom: 4),
                  //   child: normalText(title: 'Setting', textSize: 14.0),
                  // ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(6.0),
                  //     color: listTileColor,
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       ListTile(
                  //         onTap: () {},
                  //         leading: SvgPicture.asset(
                  //           'assets/svg/keyboard.svg',
                  //           width: 15,
                  //           height: 18,
                  //           color: whiteColor,
                  //         ),
                  //
                  //         trailing: Container(
                  //           width: 80,
                  //           child: FlutterSwitch(
                  //             width: 65.0,
                  //             height: 30.0,
                  //             valueFontSize: 12.0,
                  //             toggleSize: 20.0,
                  //             value: switchProvider.status,
                  //             borderRadius: 20.0,
                  //             padding: 6.0,
                  //             showOnOff: true,
                  //             onToggle: (val) {
                  //               switchProvider.toggleSwitch(context, val);
                  //             },
                  //           ),
                  //         ),
                  //         title: Padding(
                  //           padding: const EdgeInsets.only(left: 2.0, right: 2),
                  //           child: Text(
                  //             'Use the Roller Mode',
                  //             style: TextStyle(
                  //               color: whiteColor,
                  //               fontSize: 14,
                  //               fontFamily: "Poppins",
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       settingListDrawer(
                  //         ontap: () {
                  //           _showUnitSelectionDialog(context);
                  //         },
                  //         assetsvg: 'assets/svg/weight.svg',
                  //         title: 'Weight',
                  //         subtitle: switchProvider.selectedUnit,
                  //       ),
                  //       settingListDrawer(
                  //         ontap: () {
                  //           _showSoundSelectionDialog(context);
                  //         },
                  //         assetsvg: 'assets/svg/notification.svg',
                  //         title: 'Notification Sound',
                  //         // subtitle: switchProvider.selectedSound?.name ??
                  //         //     'Select a Sound',
                  //         subtitle: 'Beep 1',
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                      right: 8,
                      bottom: 4
                    ),
                    child: normalText(title: languageProvider.translate('data'), textSize: 14.0),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: listTileColor,
                    ),
                    child: Column(
                      children: [
                        listTileDrawer(
                          ontap: () {
                            Navigator.push(context, CupertinoPageRoute(builder: (context)=>  DataImport()));
                          },
                          assetsvg: 'assets/svg/importDB.svg',
                          title: languageProvider.translate('import_database'),
                        ),
                        listTileDrawer(
                          ontap: () {
                            Navigator.push(context, CupertinoPageRoute(builder: (context)=>  DataExport()));
                          },
                          assetsvg: 'assets/svg/exportDB.svg',
                          title: languageProvider.translate('export_database'),
                        ),
                        listTileDrawer(
                          ontap: () {
                            Navigator.push(context, CupertinoPageRoute(builder: (context)=> const ExportScreen()));
                            // CustomMotionToast.showSuccessToast(context, "This option will be implemented", "Next Milestone");

                          },
                          assetsvg: 'assets/svg/exportcsv.svg',
                          title: languageProvider.translate('export_csv'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 8, top: 12, bottom: 4),
                    child: normalText(title: languageProvider.translate('about'), textSize: 14.0),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: listTileColor,
                    ),
                    child: Column(
                      children: [
                        listTileDrawer(
                          ontap: () {
                            return _openMap();
                          },
                          assetsvg: 'assets/svg/star.svg',
                          title: languageProvider.translate('rate_this_app'),
                        ),
                        listTileDrawer(
                          ontap: () {
                            return _Share();
                          },
                          assetsvg: 'assets/svg/share.svg',
                          title: languageProvider.translate('share_app'),
                        ),
                        listTileDrawer(
                          ontap: () {
                            showDialog(context: context, builder: (context) {
                              return Theme(
                                data: ThemeData(
                                  canvasColor: leadingBtnColor,
                                ),
                                child: AlertDialog(

                                  backgroundColor: leadingBtnColor,
                                  title: normalText(

                                      title: languageProvider.translate('preference_for_ads'),
                                      color: whiteColor,
                                      textSize: 18.0),
                                  content: normalText(title:
                                  languageProvider.translate('preference_dialog_description'),
                                      color: whiteColor,
                                      textSize: 12.0
                                  ),
                                  actions: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0, top: 18),
                                      child: SubmitButtonnoPadding(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        titlee:   languageProvider.translate('preference_dialog_description_accept'),
                                        primaryColor: goldenColor,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,
                                          right: 8.0,
                                          bottom: 18,
                                          top: 10),
                                      child: InkWell(
                                        child: normalText(
                                            title: languageProvider.translate('preference_dialog_description_cannel'),
                                            color: whiteColor,
                                            textSize: 8.0),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),

                                    ),

                                  ],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  titlePadding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 15),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 25),
                                  actionsPadding: EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  actionsAlignment: MainAxisAlignment.center,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                ),
                              );
                            });
                          },
                          assetsvg: 'assets/svg/preferenceforads.svg',
                          title: languageProvider.translate('preference_for_ads'),
                        ),
                        listTileDrawer(
                          ontap: () async {
                            const facebookProfileUrl = 'https://www.google.com';
                            _launchYoutubeVideo(facebookProfileUrl);
                          },
                          assetsvg: 'assets/svg/prvacypolicy.svg',
                          title:  languageProvider.translate('privacy_policy'),
                        ),
                        listTileDrawer(
                          ontap: () {
                            showDialog(context: context, builder: (context) {
                              return Theme(
                                data: ThemeData(
                                  canvasColor: leadingBtnColor,
                                ),
                                child: AlertDialog(

                                  backgroundColor: leadingBtnColor,
                                  title: normalText(title:
                                  languageProvider.translate('about'),
                                      color: whiteColor,
                                      textSize: 18.0),
                                  content: normalText(title:
                                  languageProvider.translate('about_us_dialog_description'),
                                      color: whiteColor,
                                      textSize: 12.0
                                  ),
                                  actions: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,
                                          right: 8.0,
                                          bottom: 18,
                                          top: 10),
                                      child: SubmitButtonnoPadding(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        titlee:
                                        languageProvider.translate('ok'),
                                        primaryColor: goldenColor,
                                      ),
                                    ),
                                  ],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  titlePadding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 15),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 25),
                                  actionsPadding: EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  actionsAlignment: MainAxisAlignment.center,
                                ),
                              );
                            });
                          },
                          assetsvg: 'assets/svg/aboutus.svg',
                          title:
                          languageProvider.translate('about_us'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        })
    );
  }
}
