import 'package:final_water_managment/dashboard/dashboard_screen.dart';
import 'package:final_water_managment/login/login_screen.dart';
import 'package:final_water_managment/shared/constant.dart';
import 'package:final_water_managment/splash_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Constants.fetchUserToken();
  await Constants.fetchUserName();
  await Constants.fetchUserEmail();
  await Constants.fetchUserGoal();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: FutureBuilder(
        // Replace 'Duration(seconds: 2)' with your desired duration
        future: Future.delayed(Duration(seconds: 2)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Check if the user is logged in and decide which screen to show
            return Constants.userToken != '' ? DashboardScreen() : LoginScreen();
          } else {
            // While waiting for the delay, show the splash screen
            return SplashScreen();
          }
        },
      ),
    );
  }
}