import 'package:flutter/material.dart';

import '../screens/company_screen.dart';
import '../screens/latest_screen.dart';
import '../screens/upcoming_screen.dart';
import '../screens/home_screen.dart';
import '../screens/vehicles_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  static const List<Widget> _screensOptions = <Widget>[
    HomeScreen(),
    VehiclesScreen(),
    UpcomingScreen(),
    LatestScreen(),
    CompanyScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _screensOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor:
              Theme.of(context).primaryIconTheme.color?.withAlpha(180),
          showUnselectedLabels: true,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.adb),
              label: 'Vehicles',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              label: 'Upcoming',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.collections),
              label: 'Latest',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.domain),
              label: 'Company',
            )
          ],
        ));
  }
}
