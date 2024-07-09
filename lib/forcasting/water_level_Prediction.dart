import 'dart:convert';
import 'dart:io';
import 'package:final_water_managment/shared/components.dart';
import 'package:final_water_managment/shared/constant.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WaterLevelPrediction extends StatefulWidget {
  @override
  WaterLevelPredictionState createState() => WaterLevelPredictionState();
}

class WaterLevelPredictionState extends State<WaterLevelPrediction> {
  var formKey = GlobalKey<FormState>();
  var hourController = TextEditingController();
  var dayOfWeekController = TextEditingController();
  var quarterController = TextEditingController();
  var monthController = TextEditingController();
  var yearController = TextEditingController();
  var dayOfYearController = TextEditingController();
  var dayOfMonthController = TextEditingController();
  String predictionResult = '';
  bool isLoading = false;
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Water Level Prediction', style: TextStyle(color: Colors.black),),
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
                    controller: hourController,
                    text: 'Hour',
                    enable: isEnabled,
                    prefix: Icons.hourglass_bottom,
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
                    controller: dayOfWeekController,
                    text: 'Day of week',
                    enable: isEnabled,
                    prefix: Icons.hourglass_bottom,
                    validate: (value) {
                      if (value!.isEmpty) return 'Day of week must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: quarterController,
                    text: 'Quarter',
                    enable: isEnabled,
                    prefix: Icons.hourglass_bottom,
                    validate: (value) {
                      if (value!.isEmpty) return 'Quarter must not be empty';
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
                    prefix: Icons.hourglass_bottom,
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
                    controller: yearController,
                    text: 'Year',
                    enable: isEnabled,
                    prefix: Icons.hourglass_bottom,
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
                    controller: dayOfYearController,
                    text: 'Day of year',
                    enable: isEnabled,
                    prefix: Icons.hourglass_bottom,
                    validate: (value) {
                      if (value!.isEmpty) return 'Day of year must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: dayOfMonthController,
                    text: 'Day of month',
                    enable: isEnabled,
                    prefix: Icons.hourglass_bottom,
                    validate: (value) {
                      if (value!.isEmpty) return 'Day of month must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  defaultTextButton(
                    text: 'Predict',
                    onPressed: () async{
                      if (formKey.currentState!.validate()) {
                        try{
                          final hour = double.parse(hourController.text);
                          final dayOfWeek =
                              double.parse(dayOfWeekController.text);
                          final quarter = double.parse(quarterController.text);
                          final month = double.parse(monthController.text);
                          final year = double.parse(yearController.text);
                          final dayOfYear =
                              double.parse(dayOfYearController.text);
                          final dayOfMonth =
                              double.parse(dayOfMonthController.text);

                          setState(() {
                            isLoading = true;
                            isEnabled = false;
                          });

                          await sendPredictionRequest(hour, dayOfWeek, quarter,
                              month, year, dayOfYear, dayOfMonth);

                          setState(() {
                            isLoading = false;
                            isEnabled = true;
                          });
                        }catch (e) {
                          // Handle the parsing error
                          print('Error parsing double: $e');
                          showResultDialog(false, 'Please enter valid numeric values for all fields.');
                        }
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

  // Your sendPredictionRequest and other methods go here
  Future<void> sendPredictionRequest(
      double hour,
      double dayOfWeek,
      double quarter,
      double month,
      double year,
      double dayOfYear,
      double dayOfMonth,
      ) async {
    final apiUrl = 'https://watermanagement-b6i3.onrender.com/level';

    try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Constants.userToken}'
      },
      body: jsonEncode(
          {
            "hour" : hour,
            "dayofweek" : dayOfWeek,
            "quarter" : quarter,
            "month" : month,
            "year" : year,
            "dayofyear" : dayOfYear,
            "dayofmonth" : dayOfMonth,
          }
      ),
    );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        // Assuming your API response contains an 'output' field
        predictionResult = responseData['output'].toString();

        // Update the UI with a custom message
        setState(() {
          predictionResult = 'The level of water is $predictionResult';
        });

        showResultDialog(true, '');
        // This triggers a UI rebuild
      }else if (response.statusCode == 500){
        // Handle errors or other status codes
        print('API request failed with status: ${jsonDecode(response.body)}');
        showResultDialog(false, 'Prediction not found. ${jsonDecode(response.body)['message']}');
      } 
      else {
        // Handle errors or other status codes
        print('API request failed with status: ${response.statusCode}');
        showResultDialog(false, 'Prediction not found. Please check your input and try again.');
      }
    } catch (e) {
      showResultDialog(false, 'An unexpected error occurred. Please check your internet connection and try again.');
    }
  }

  void showResultDialog(bool isSuccess, String message) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: isSuccess ? Text('Prediction Success') : Text('Prediction Failed'),
          content: Text(isSuccess ? predictionResult : message),
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
}