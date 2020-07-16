import 'package:deepfake_app/components/app_bar.dart';
import 'package:deepfake_app/globals.dart';
import 'package:deepfake_app/screens/about_screen.dart';
import 'package:deepfake_app/screens/classify_screen.dart';
import 'package:deepfake_app/screens/history_screen.dart';
import 'package:deepfake_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'colors.dart';
import 'screens/home_screen.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final titles = ["Home", "Classify", "History", "About Us"];
  int _currentIndex = 0;
  HomeScreen homeScreen;
  final screens = [
    ClassifyScreen(),
    HistoryScreen(),
    AboutScreen(),
  ];

  @override
  void initState() {
    super.initState();
    homeScreen = HomeScreen(callback: this.callback);
    screens.insert(0, homeScreen);
  }

  void callback(int i) {
    setState(() {
      _currentIndex = i;
    });
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: !loggedIn
          ? LoginScreen()
          : Scaffold(
              body: screens[_currentIndex],
              backgroundColor:
                  isDark ? DeepfakeColors.background : Colors.white,
              appBar: DeepfakeAppBar(
                  title: titles[_currentIndex],
                  onChange: () {
                    this.setState(() {});
                  }),
              bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey[300],
                currentIndex: _currentIndex,
                items: [
                  BottomNavigationBarItem(
                    backgroundColor: DeepfakeColors.secondary,
                    title: Text(
                      'Home',
                    ),
                    icon: Icon(
                      FontAwesomeIcons.home,
                    ),
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: DeepfakeColors.secondary,
                    title: Text('Classify'),
                    icon: Icon(
                      FontAwesomeIcons.atom,
                    ),
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: DeepfakeColors.secondary,
                    title: Text('History'),
                    icon: Icon(
                      FontAwesomeIcons.history,
                    ),
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: DeepfakeColors.secondary,
                    title: Text('About Us'),
                    icon: Icon(
                      FontAwesomeIcons.users,
                    ),
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
    );
  }
}
