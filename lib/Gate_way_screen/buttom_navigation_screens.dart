import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mikococo/calender/calender_screen.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/homescreen/home_screen.dart';
import 'package:mikococo/routine/MyRoutineClass.dart';
import 'package:mikococo/timer/timer_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  var _selectedindexx = 0 ;
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedindexx = index;
  //   });
  //   print(_selectedindexx);
  // }
  void _onItemTapped(int index) {
    // if (index == 1) {
    //   // If the selected item is the CalenderScreen, navigate to a new screen
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => HomeScreen(null)),
    //   );
    //   print(index);}
    //  if (index == 2) {
    //   // If the selected item is the CalenderScreen, navigate to a new screen
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => TimerScreen()),
    //   );
    // }
    //  if (index == 3) {
    //   // If the selected item is the CalenderScreen, navigate to a new screen
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => CalenderScreen()),
    //   );
    // }
    // Define a list of destinations for each index
    List<Widget> destinations = [
      MyRoutinesScreen(),
      HomeScreen(null,isExerciseScreen: false,),
      TimerScreen(),
      ShareScreen(),
    ];

    // Check if the index corresponds to a specific destination
    if (index >= 0 && index < destinations.length) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destinations[index ]),
      );
      print(index);
    }
    else {
      // If the selected item is not CalenderScreen, update the selected index
      setState(() {
        _selectedindexx = index;
      });
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: listTileColor,
        // currentIndex: _selectedindexx,
        unselectedItemColor: listTileColor,
        backgroundColor: blackColor,
        onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(icon: SvgPicture.asset('assets/svg/homeicon.svg', width: 20,),label: 'workoout'),
            BottomNavigationBarItem(icon: SvgPicture.asset('assets/svg/dumbel.svg'), label: 'exercises'),
            BottomNavigationBarItem(icon: SvgPicture.asset('assets/svg/clock.svg'), label: 'Timer'),
            BottomNavigationBarItem(icon: SvgPicture.asset('assets/svg/calnder.svg'),label: 'Calender'),
          ]
      ),
      body: screens[_selectedindexx],
    );
  }
}
