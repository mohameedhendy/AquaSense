import 'dart:convert';
import 'dart:io';
import 'package:final_water_managment/shared/components.dart';
import 'package:final_water_managment/shared/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AccelerometerBranched extends StatefulWidget {
  @override
  State<AccelerometerBranched> createState() => _AccelerometerBranchedState();
}

class _AccelerometerBranchedState extends State<AccelerometerBranched> {
  var formKey = GlobalKey<FormState>();

  var sensor1Controller = TextEditingController();

  var sensor2Controller = TextEditingController();

  var sensor3Controller = TextEditingController();

  var sensor4Controller = TextEditingController();

  var sensor5Controller = TextEditingController();

  var sensor6Controller = TextEditingController();

  var sensor7Controller = TextEditingController();

  var sensor8Controller = TextEditingController();

  String predictionResult = '';
  bool isLoading = false;
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Accelerometer Branched', style: TextStyle(color: Colors.black),),
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
                    controller: sensor1Controller,
                    text: 'Sensor 1',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Sensor1 must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: sensor2Controller,
                    text: 'Sensor2',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Sensor2 must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: sensor3Controller,
                    text: 'Sensor3',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Sensor3 must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: sensor4Controller,
                    text: 'Sensor4',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Sensor4 must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: sensor5Controller,
                    text: 'Sensor5',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Sensor5 must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: sensor6Controller,
                    text: 'Sensor6',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Sensor6 must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: sensor7Controller,
                    text: 'Sensor7',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Sensor7 must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: sensor8Controller,
                    text: 'Sensor8',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Sensor8 must not be empty';
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
                        // Call the prediction method
                        try{
                          final sensor1 = double.parse(sensor1Controller.text);
                          final sensor2 = double.parse(sensor2Controller.text);
                          final sensor3 = double.parse(sensor3Controller.text);
                          final sensor4 = double.parse(sensor4Controller.text);
                          final sensor5 = double.parse(sensor5Controller.text);
                          final sensor6 = double.parse(sensor6Controller.text);
                          final sensor7 = double.parse(sensor7Controller.text);
                          final sensor8 = double.parse(sensor8Controller.text);

                          setState(() {
                            isLoading = true;
                            isEnabled = false;
                          });

                          await sendPredictionRequest(sensor1, sensor2, sensor3,
                              sensor4, sensor5, sensor6, sensor7, sensor8);

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

  Future<void> sendPredictionRequest(
      double sensor1,
      double sensor2,
      double sensor3,
      double sensor4,
      double sensor5,
      double sensor6,
      double sensor7,
      double sensor8,
      ) async {
    final apiUrl = 'https://watermanagement-b6i3.onrender.com/leak/accelerometerbranched';

    try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Constants.userToken}'
      },
      body: jsonEncode({
        'sensor1': sensor1,
        'sensor2': sensor2,
        'sensor3': sensor3,
        'sensor4': sensor4,
        'sensor5': sensor5,
        'sensor6': sensor6,
        'sensor7': sensor7,
        'sensor8': sensor8,
      }),
    );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        // Assuming your API response contains an 'output' field
        predictionResult = responseData['leakType'];

        // Update the UI with the result
        setState(() {
          if(predictionResult == 'NonLeak')
            {
              predictionResult = predictionResult;
            }
          else
            {
              predictionResult = 'The type of leak is $predictionResult';
            }
        });

        showResultDialog(true, '');
        // This triggers a UI rebuild
      } else {
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