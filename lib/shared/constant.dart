import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static String userToken = '';
  static String  userEmail = '';
   static String  userName = '';
  static var  userGoal;
  static var consumptionResult;



  static Future<void> fetchUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('userToken') ?? ''; // Use empty string if null
    print('Fetched userToken: $userToken');
  }

  static Future<void> updateUserToken(String token) async {
    userToken = token;

    // Save the token in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userToken', token);
  }

  static Future<void> fetchUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName') ?? ''; // Use empty string if null
    print('Fetched userName: $userName');
  }

  static Future<void> updateUserName(String name) async {
    userName = name;

    // Save the token in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', name);
  }

  static Future<void> fetchUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('userEmail') ?? ''; // Use empty string if null
    print('Fetched userEmail: $userEmail');
  }

  static Future<void> updateUserEmail(String email) async {
    userEmail = email;

    // Save the token in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userEmail', email);
  }

  static Future<void> fetchUserGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userGoal = prefs.getString('userGoal') ?? ''; // Use empty string if null
    print('Fetched userGoal: $userGoal');
  }

  static Future<void> updateUserGoal(String goal) async {
    userGoal = goal;

    // Save the token in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userGoal', goal);
  }

  static Future<void> fetchConsumptionResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    consumptionResult = prefs.getString('consumptionResult') ?? ''; // Use empty string if null
  }

  static Future<void> updateConsumptionResult(var result) async {
    consumptionResult = result;

    // Save the Goal in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('consumptionResult',result);
  }

}
