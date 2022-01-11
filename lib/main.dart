import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/favorites.dart';
import 'providers/launchpad.dart';
import 'providers/theme.dart';
import 'screens/company_screen.dart';
import 'screens/home_screen.dart';
import 'screens/latest_screen.dart';
import 'screens/launch_details_screen.dart';
import 'screens/launchpad_screen.dart';
import 'screens/upcoming_screen.dart';
import 'screens/vehicle_details_screen.dart';
import 'screens/vehicles_screen.dart';
import 'widgets/bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: LaunchpadProvider(),
          ),
          ChangeNotifierProvider.value(
            value: ThemeProvider(),
          ),
          ChangeNotifierProvider.value(
            value: FavoritesProvider(),
          ),
        ],
        child: Consumer<ThemeProvider>(builder: (context, theme, child) {
          return MaterialApp(
            home: const SafeArea(
                child: Scaffold(bottomNavigationBar: BottomBar())),
            theme: ThemeData(
                primaryColor: Colors.orange,
                colorScheme:
                    ColorScheme.fromSwatch(primarySwatch: Colors.orange),
                cardColor: Colors.grey.shade200),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.orange.shade900,
              colorScheme: ColorScheme.dark(
                  primary: Colors.deepOrange,
                  surface: Colors.orange.shade900,
                  brightness: Brightness.dark),
            ),
            themeMode: theme.themeMode,
            initialRoute: '/',
            routes: {
              HomeScreen.routeName: (ctx) => const HomeScreen(),
              VehiclesScreen.routeName: (ctx) => const VehiclesScreen(),
              VehicleDetailsScreen.routeName: (ctx) => VehicleDetailsScreen(),
              UpcomingScreen.routeName: (ctx) => const UpcomingScreen(),
              LaunchDetails.routeName: (ctx) => LaunchDetails(),
              LaunchpadScreen.routeName: (ctx) => const LaunchpadScreen(),
              LatestScreen.routeName: (ctx) => const LatestScreen(),
              CompanyScreen.routeName: (ctx) => const CompanyScreen(),
            },
          );
        }));
  }
}
