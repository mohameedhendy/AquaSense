import 'package:final_water_managment/dashboard/web_view.dart';
import 'package:final_water_managment/forcasting/home_page.dart';
import 'package:final_water_managment/help_screen.dart';
import 'package:final_water_managment/login/login_screen.dart';
import 'package:final_water_managment/maps/map_page.dart';
import 'package:final_water_managment/news/news_page.dart';
import 'package:final_water_managment/shared/components.dart';
import 'package:final_water_managment/shared/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var height, width;

  String userEmail = Constants.userEmail;

  String encodedEmail = Uri.encodeComponent(Constants.userEmail);

  TextEditingController goalController = TextEditingController();

  // late SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF005792),
        title: Text(
          'AquaSence',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.0,
      ),
      drawer: MyDrawer(),
      body: Container(
        color: Color(0xFF005792),
        height: height,
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height * 0.02,
              width: width,
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.07,bottom: height * 0.05 ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dashboard', style: TextStyle(color: Colors.white, fontSize: 25,),),
                  SizedBox(height: height * 0.007,),
                  Text('Updated every minute', style: TextStyle(color: Colors.grey, fontSize: 15,),)
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    // First iframe
                    Flexible(
                      child: WebViewContainer(
                        iframeUrl:
                        'https://charts.mongodb.com/charts-aquago-zczxo/embed/charts?id=656e47a2-d7f5-4e16-8bcb-78b1635c5d7b&maxDataAge=60&theme=light&autoRefresh=true&filter=%7B%22email%22:%22$encodedEmail%22%7D',
                      ),
                    ),
                    // Second iframe
                    Flexible(
                      child: WebViewContainer(
                        iframeUrl:
                            'https://charts.mongodb.com/charts-aquago-zczxo/embed/charts?id=656e6d73-dbb3-4c65-8a7b-6bf7255d72a7&maxDataAge=60&theme=light&autoRefresh=true&filter=%7B%22email%22:%22$encodedEmail%22%7D',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the dialog to add a goal
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Goal'),
                content: TextField(
                  controller: goalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Enter your goal'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Save the goal to SharedPreferences
                      Constants.updateUserGoal(goalController.text);
                      sendGoalToApi(goalController.text);
                      // Close the dialog
                      Navigator.pop(context);
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> sendGoalToApi(var goal) async {

    final apiUrl = 'https://watermanagement-b6i3.onrender.com/myconsumption?goal=${Constants.userGoal}';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.userToken}'
        },
      );

      if (response.statusCode == 201) {
        // Successfully sent result to the other API
        print('Goal sent to another API successfully');
      } else {
        // Handle errors or other status codes
        print('API request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions here (e.g., network errors or JSON parsing errors)
      print('An error occurred: $e');
    }
  }
}

class MyDrawer extends StatefulWidget {
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  var height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    void logout() async {
      // Clear user token and update SharedPreferences
      Constants.updateUserToken('');
      Constants.updateUserName('');
      Constants.updateUserEmail('');
      Constants.updateUserGoal('');

      // Navigate to the login screen
      navigateAndFinish(context, LoginScreen());
    }

    return Drawer(
      backgroundColor: Color(0xFF005792),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              '${Constants.userName}',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            accountEmail: Text(
              '${Constants.userEmail}',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                CupertinoIcons.person,
                color: Color(0xFF005792),
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF005792),
            ),
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.news,
              color: Colors.white,
            ),
            title: Text(
              'News',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            onTap: () {
              navigaiteTo(context, NewsPage());
            },
          ),
          ListTile(
            leading: Icon(
              Icons.online_prediction,
              color: Colors.white,
            ),
            title: Text(
              'Forecasting',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            onTap: () {
              navigaiteTo(context, ForecastingHomePage());
            },
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.map_pin_ellipse,
              color: Colors.white,
            ),
            title: Text(
              'Water Sources Map',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            onTap: () {
              navigaiteTo(context, MapScreen());
            },
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.question_circle,
              color: Colors.white,
            ),
            title: Text(
              'How it works ?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            onTap: () {
              navigaiteTo(context, HelpScreen());
            },
          ),
          Spacer(),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            title: Text(
              'Sign Out',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            onTap: () {
              logout();
            },
          ),
        ],
      ),
    );
  }
}