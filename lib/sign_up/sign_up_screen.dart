import 'dart:convert';
import 'package:final_water_managment/login/login_screen.dart';
import 'package:final_water_managment/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isPasswordVisible = false;
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
                    'SIGN UP',
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
                      controller: nameController,
                      text: 'Name',
                      enabled: isEnabled,
                      prefix: Icons.person,
                      validate: (value) {
                        if (value!.isEmpty) return 'Name must not be empty';
                        return null;
                      },
                      type: TextInputType.name,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.077,
                    child: defaultFormFieldLogin(
                      controller: emailController,
                      text: 'Email',
                      enabled: isEnabled,
                      prefix: Icons.email,
                      validate: (value) {
                        if (value!.isEmpty) return 'E-mail must not be empty';
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
                      validate: (value) {
                        if (value!.isEmpty) return 'Password must not be empty';
                        return null;
                      },
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
                      obsecure: !isPasswordVisible,
                      type: TextInputType.visiblePassword,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  defaultTextButton(
                    text: 'SIGN UP',
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final String name = nameController.text;
                        final String email = emailController.text;
                        final String password = passwordController.text;

                        // Show loading indicator
                        setState(() {
                          isLoading = true;
                          isEnabled = false;
                        });

                        await signUp(name, email, password);

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
                        'Already have an account?',
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
                            navigaiteTo(context, LoginScreen());
                          },
                          child: Text(
                            'Log In',
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

  Future<void> signUp(String name, String email, String password) async {
    final String apiUrl = 'https://watermanagement-b6i3.onrender.com/signup';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      if (response.statusCode == 201) {
        // Successfully signed up
        print('Successfully signed up!');
        navigaiteTo(context, LoginScreen());
      } else if (response.statusCode == 401) {
        // User already signed up
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Registration Error'),
              content: Text('The provided email is already registered. Please log in.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    navigaiteTo(context, LoginScreen());
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Handle other errors
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Registration Error'),
              content: Text('Failed to sign up. Please check your data and try again.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
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