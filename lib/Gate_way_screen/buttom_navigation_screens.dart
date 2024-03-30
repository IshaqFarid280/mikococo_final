import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mikococo/calender/calender_screen.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/homescreen/home_screen.dart';
import 'package:mikococo/module/models.dart';
import 'package:mikococo/routine/MyRoutineClass.dart';
import 'package:mikococo/timer/timer_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  // final _todosBox = Hive.box<Routine>('RoutineBox');
  // String _currentLanguage = 'en';
  var _selectedindexx = 0 ;
  //
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  // GlobalKey<RefreshIndicatorState>();
  //
  // Future<void> _initializeApp() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   _currentLanguage = prefs.getString('language_code') ?? 'en';
  //
  //   await _loadDemoData();
  //   await _updateDemoData();
  // }
  //
  // Future<void> _loadDemoData() async {
  //   if (_todosBox.isEmpty) {
  //     _todosBox.add(Routine('Task 1', 'This is task 1', 'T1', '#ffffff' ,  [1]));
  //     _todosBox.add(Routine('Task 2', 'This is task 2', 'T2', '#f6f6f6' ,  [2]));
  //     _todosBox.add(Routine('Task 3', 'This is task 3', 'T3', '#ffffff' ,  [3]));
  //   } else {
  //     await _updateDemoData();
  //   }
  // }
  //
  // Future<void> _updateDemoData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString('language_code', _currentLanguage);
  //
  //   switch (_currentLanguage) {
  //     case 'es':
  //       _todosBox.putAt(
  //           0, Routine('Tarea 1', 'Esta es la tarea 1', 'T1', '#ffffff' ,  [1]));
  //       _todosBox.putAt(
  //           1, Routine( 'Tarea 2', 'Esta es la tarea 2',  'T2', '#f6f6f6' ,  [2]));
  //       _todosBox.putAt(
  //           2, Routine( 'Tarea 3', 'Esta es la tarea 3',  'T3', '#f6f6f6' ,  [3]));
  //       break;
  //     case 'ar':
  //       _todosBox.putAt(
  //           0, Routine( 'مهمة 1',  'هذه هي المهمة 1', 'T1', '#ffffff' ,  [1]));
  //       _todosBox.putAt(
  //           1, Routine( 'مهمة 2',  'هذه هي المهمة 2', 'T2', '#ffffff' ,  [1]));
  //       _todosBox.putAt(
  //           2,Routine( 'مهمة31',  'هذه هي المهمة 3', 'T3', '#ffffff' ,  [1]));
  //       break;
  //     case 'ru':
  //       _todosBox.putAt(
  //           0, Routine('Задача 1', 'Это задача 1', 'T1', '#ffffff' ,  [1]));
  //       _todosBox.putAt(
  //           1, Routine('Задача 2', 'Это задача 2', 'T2', '#ffffff' ,  [1]));
  //       _todosBox.putAt(
  //           2, Routine('Задача 3', 'Это задача 3', 'T3', '#ffffff' ,  [1]));
  //       break;
  //     default:
  //       _todosBox.putAt(
  //           0, Routine('Tarea 1', 'Esta es la tarea 1', 'T1', '#ffffff' ,  [1]));
  //       _todosBox.putAt(
  //           1, Routine( 'Tarea 2', 'Esta es la tarea 2',  'T2', '#f6f6f6' ,  [2]));
  //       _todosBox.putAt(
  //           2, Routine( 'Tarea 3', 'Esta es la tarea 3',  'T3', '#f6f6f6' ,  [3]));
  //   }
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Language changed to $_currentLanguage'),
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  //
  //   setState(() {}); // Manually trigger a rebuild when language changes
  // }
  //
  // Future<void> _onRefresh() async {
  //   await _loadDemoData();
  //   print('rebuild in refresh');
  //   await _updateDemoData();
  //   setState(() {});
  // }

  void _onItemTapped(int index) {
    if (index == 1) {
      // If the selected item is the CalenderScreen, navigate to a new screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(null)),
      );
      print(index);}
     if (index == 2) {
      // If the selected item is the CalenderScreen, navigate to a new screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TimerScreen()),
      );
    }
     if (index == 3) {
      // If the selected item is the CalenderScreen, navigate to a new screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShareScreen()),
      );
    }
  }
  List<Widget> screens = [
    MyRoutinesScreen(),
    HomeScreen(null),
    TimerScreen(),
    ShareScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          highlightColor: transparentColor,
          splashColor: transparentColor,
          hoverColor: transparentColor,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: listTileColor,
          unselectedItemColor: listTileColor,
          backgroundColor: blackColor,
          onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(icon: SvgPicture.asset('assets/svg/homeicon.svg', width: 20,),label: '',),
              BottomNavigationBarItem(icon: SvgPicture.asset('assets/svg/dumbel.svg'), label: ''),
              BottomNavigationBarItem(icon: SvgPicture.asset('assets/svg/clock.svg'), label: ''),
              BottomNavigationBarItem(icon: SvgPicture.asset('assets/svg/calnder.svg'),label: ''),
            ]
        ),
      ),
      body: screens[_selectedindexx],
    );
  }
}
