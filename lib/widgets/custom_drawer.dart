import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex/providers/theme.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isSwitched = false;
  String selectedThemeValue = 'Selected theme is light';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    isSwitched = themeProvider.themeMode == ThemeMode.light ? false : true;
    selectedThemeValue = themeProvider.themeMode == ThemeMode.light
        ? 'Selected theme is light'
        : 'Selected theme is dark';

    void toggleSwitch(bool value) {
      if (isSwitched == false) {
        setState(() {
          isSwitched = true;
          selectedThemeValue = 'Selected theme is dark';
          themeProvider.updateThemeMode(ThemeMode.dark);
        });
      } else {
        setState(() {
          isSwitched = false;
          selectedThemeValue = 'Selected theme is light';
          themeProvider.updateThemeMode(ThemeMode.light);
        });
      }
    }

    return Drawer(
        child: ListView(
      children: [
        SizedBox(
          height: 60,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Text('Settings'),
          ),
        ),
        ListTile(
          title: Column(
            children: [
              const Text('Theme'),
              Switch(
                onChanged: toggleSwitch,
                value: isSwitched,
                activeColor: Theme.of(context).primaryColor,
                activeTrackColor: Colors.yellow,
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey,
              ),
              Text(selectedThemeValue, style: const TextStyle(fontSize: 20))
            ],
          ),
        ),
      ],
    ));
  }
}
