import 'package:flutter/material.dart';
import 'package:mikococo/homescreen/home_screen.dart';
import 'package:mikococo/routine/MyRoutineClass.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  var indexx = 1 ;
  List<Widget> screens = [
    HomeScreen(null),
    MyRoutinesScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        onTap: (index){
             indexx = index;
           setState(() {
           });
        },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.abc_rounded),label: 'exercises'),
            BottomNavigationBarItem(icon: Icon(Icons.access_alarm),label: 'workoout'),
          ]
      ),
      body: screens[indexx],
    );
  }
}
