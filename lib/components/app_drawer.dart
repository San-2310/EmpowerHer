import 'package:empower_her/views/feedback_screen/feedback_screen.dart';
import 'package:flutter/material.dart';

import '../views/home_screen/home_screen.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(174, 175, 247, 1),
                  Color(0xFFC5DEE3),
                ],
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "EmpowerHer",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text("Home"),
            leading: Icon(Icons.home),
            selected: currentRoute == '/home',
            selectedTileColor: Color.fromRGBO(253, 221, 236, 1),
            onTap: () {
              if (currentRoute != '/home') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            title: Text("Feedback"),
            leading: Icon(Icons.info),
            selected: currentRoute == '/feedback',
            selectedTileColor: Color.fromRGBO(253, 221, 236, 1),
            onTap: () {
              if (currentRoute != '/feedback') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedbackScreen()));
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
