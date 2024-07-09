import 'dart:convert';
import 'package:final_water_managment/dashboard/dashboard_screen.dart';
import 'package:final_water_managment/help_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:final_water_managment/shared/components.dart';
import 'package:final_water_managment/shared/constant.dart';
import 'package:final_water_managment/sign_up/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool isPasswordVisible = false; // Track password visibility
  bool isLoading = false;
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.teal],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Text(
                    'LOGIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.077,
                    child: defaultFormFieldLogin(
                      controller: emailController,
                      text: 'Email',
                      enabled: isEnabled,
                      prefix: Icons.email,
                      validate: (value) {
                        if (value!.isEmpty) return 'Email must not be empty';
                        return null;
                      },
                      type: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.077,
                    child: defaultFormFieldLogin(
                      controller: passwordController,
                      text: 'Password',
                      enabled: isEnabled,
                      prefix: Icons.lock,
                      suffix: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      obsecure: !isPasswordVisible, // Toggle password visibility
                      type: TextInputType.visiblePassword,
                      validate: (value) {
                        if (value!.isEmpty) return 'Password must not be empty';
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  defaultTextButton(
                    text: 'LOGIN',
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final String email = emailController.text;
                        final String password = passwordController.text;

                        // Show loading indicator
                        setState(() {
                          isLoading = true;
                          isEnabled = false;
                        });

                        await loginUser(email, password);

                        // Hide loading indicator
                        setState(() {
                          isLoading = false;
                          isEnabled = true;
                        });
                      }
                    },
                    isLoading: isLoading,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 35,
                        decoration: BoxDecoration(
                          // color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          border: Border.all(color: Colors.white),
                        ),
                        child: TextButton(
                          onPressed: () {
                            navigaiteTo(context, SignUpScreen());
                          },
                          child: Text(
                            'Register Now',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser(String email, String password) async {
    final String apiUrl =
        'https://watermanagement-b6i3.onrender.com/login'; // Replace with your API endpoint.

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String token = responseData['token'];
        String name = responseData['name'];
        String email = responseData['email'];

        // Save the token in the Constants class and SharedPreferences
        await Constants.updateUserToken(token);
        await Constants.updateUserName(name);
        await Constants.updateUserEmail(email);

        print(Constants.userToken);
        // Successful login.
        print('Successfully logged in!');
        navigateAndFinish(context, DashboardScreen());
        Fluttertoast.showToast(
          msg: 'Successfully logged in!',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        // Failed login.
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("User Not Found"),
            content:
            Text('The provided email and password are incorrect.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              )
            ],
          ),
        );
      }
    } catch (exception) {
      print('An error occurred: $exception');
      // Handle network or other exceptions
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'An error occurred. Please check your internet connection and try again'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
          );
    }
    }
}