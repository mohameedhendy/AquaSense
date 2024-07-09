import 'dart:convert';
import 'dart:io';
import 'package:final_water_managment/shared/components.dart';
import 'package:final_water_managment/shared/constant.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WaterConsumption extends StatefulWidget {
  @override
  State<WaterConsumption> createState() => _WaterConsumptionState();
}

class _WaterConsumptionState extends State<WaterConsumption> {
  var formKey = GlobalKey<FormState>();

  var yearController = TextEditingController();
  var monthController = TextEditingController();
  var dayController = TextEditingController();
  var hourController = TextEditingController();
  var minuteController = TextEditingController();
  var secondController = TextEditingController();

  var predictionResult = '';
  bool isLoading = false;
  bool isEnabled = true;


  var userGoal ;

  @override
  void initState() {
    super.initState();
    // loadSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Water Consumption', style: TextStyle(color: Colors.black),),
        elevation: 0,
        backgroundColor: Colors.white10,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 20.0, left: 20.0,bottom: 20.0),
          child: Container(
            width: double.infinity,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  defaultFormField(
                    controller: yearController,
                    text: 'Year',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Year must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: monthController,
                    text: 'Month',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Month must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: dayController,
                    text: 'Day',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Day must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: hourController,
                    text: 'Hour',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Hour must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: minuteController,
                    text: 'Minute',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Minute must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: secondController,
                    text: 'Second',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Second must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  defaultTextButton(
                    text: 'Predict',
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final year = yearController.text;
                        final month = monthController.text;
                        final day = dayController.text;
                        final hour = hourController.text;
                        final minute = minuteController.text;
                        final second = secondController.text;

                        // Show loading indicator
                        setState(() {
                          isLoading = true;
                          isEnabled = false;
                        });

                        await sendPredictionRequest(year, month, day, hour, minute, second);

                        // Hide loading indicator
                        setState(() {
                          isLoading = false;
                          isEnabled = true;
                        });
                      }
                    },
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<void> sendPredictionRequest(
      var year,
      var month,
      var day,
      var hour,
      var minute,
      var second,
      ) async {
    final apiUrl = 'http://192.168.10.63:2500/predict';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.userToken}'
        },
        body: jsonEncode({
          'year': year,
          'month': month,
          'day': day,
          'hour': hour,
          'minute': minute,
          'second': second
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
        predictionResult = responseData['predictions'][0].toString();
        Constants.updateConsumptionResult(predictionResult);
        sendResultToApi(predictionResult);

        setState(() {
          predictionResult = 'Your consumption is $predictionResult';
        });

        showResultDialog(true, '');
      } else {
        if (response.statusCode == 500) {
          // Handle 500 Not Found error
          // print('API request failed with status: ${response.statusCode}');
          showResultDialog(false,
              'Prediction not found. Please check your input and try again.');
        } else {
          // Handle other status codes
          // print('API request failed with status: ${response.statusCode}');
          showResultDialog(
              false, 'Failed to fetch prediction. Please try again.');
        }
      }
    } catch (e) {
      // Check for specific exceptions to provide more accurate error messages
      if (e is SocketException) {
        // print('An error occurred: $e');
        showResultDialog(false, 'An error occurred. Please check your internet connection and try again.', socketException: e);
      } else {
        // print('An error occurred: $e');
        showResultDialog(false, 'An unexpected error occurred. Please check your internet connection and try again.');
      }
    }
  }

  void showResultDialog(bool isSuccess, String message, {SocketException? socketException}) {
    String errorMessage = '';

    if (socketException != null) {
      if (socketException.osError?.errorCode == 110) {
        errorMessage = 'Failed to connect to the prediction server. Please try again later.';
      } else if (socketException.osError?.errorCode == 101) {
        errorMessage = 'An unexpected error occurred. Please check your internet connection and try again.';
      }else if (socketException.osError?.errorCode == 113) {
        errorMessage = 'No route to host. Please check your internet connection and try again.';
      }else {
        errorMessage = 'Unexpected socket error. Please try again.';
      }
    } else {
      errorMessage = message;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: isSuccess ? Text('Prediction Success') : Text('Prediction Failed'),
          content: Text(isSuccess ? predictionResult : errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }



  Future<void> sendResultToApi(var result) async {

    final apiUrl = 'https://watermanagement-b6i3.onrender.com/myconsumption?consumption=${Constants.consumptionResult}';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.userToken}'
        },
      );

      // if (response.statusCode == 201) {
      //   // Successfully sent result to the other API
      //   print('Result sent to another API successfully');
      // } else {
      //   // Handle errors or other status codes
      //   print('API request failed with status: ${response.statusCode}');
      // }
    } catch (e) {
      // Handle exceptions here (e.g., network errors or JSON parsing errors)
      print('An error occurred: $e');
    }
  }
}