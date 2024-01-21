import 'dart:convert';
import 'dart:io';
import 'package:final_water_managment/shared/components.dart';
import 'package:final_water_managment/shared/constant.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WaterPotabilityPrediction extends StatefulWidget {
  @override
  _WaterPotabilityPredictionState createState() =>
      _WaterPotabilityPredictionState();
}

class _WaterPotabilityPredictionState extends State<WaterPotabilityPrediction> {
  var formKey = GlobalKey<FormState>();
  var phController = TextEditingController();
  var hardnessController = TextEditingController();
  var solidController = TextEditingController();
  var chioraminesController = TextEditingController();
  var sultfateController = TextEditingController();
  var conductivityController = TextEditingController();
  var organicCarbonController = TextEditingController();
  var trihalomethanesController = TextEditingController();
  var turbidityController = TextEditingController();
  String predictionResult = '';
  bool isLoading = false;
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Water Potability Prediction', style: TextStyle(color: Colors.black),),
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
                    controller: phController,
                    text: 'pH',
                    enable: isEnabled,
                    prefix: Icons.invert_colors,
                    validate: (value) {
                      if (value!.isEmpty) return 'PH must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: hardnessController,
                    text: 'Hardness',
                    enable: isEnabled,
                    prefix: Icons.opacity,
                    validate: (value) {
                      if (value!.isEmpty) return 'Haredness must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: solidController,
                    text: 'Solid',
                    enable: isEnabled,
                    prefix: Icons.grain,
                    validate: (value) {
                      if (value!.isEmpty) return 'Solid must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: chioraminesController,
                    text: 'Chioramines',
                    enable: isEnabled,
                    prefix: Icons.local_drink,
                    validate: (value) {
                      if (value!.isEmpty)
                        return 'Chioramines must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: sultfateController,
                    text: 'Sultfate',
                    enable: isEnabled,
                    prefix: Icons.water,
                    validate: (value) {
                      if (value!.isEmpty) return 'Sultfate must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: conductivityController,
                    text: 'Conductivity',
                    enable: isEnabled,
                    prefix: Icons.flash_on,
                    validate: (value) {
                      if (value!.isEmpty)
                        return 'Conductivity must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: organicCarbonController,
                    text: 'OrganicCarbon',
                    enable: isEnabled,
                    prefix: Icons.eco,
                    validate: (value) {
                      if (value!.isEmpty)
                        return 'OrganicCarbon must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: trihalomethanesController,
                    text: 'Trihalomethanes',
                    enable: isEnabled,
                    prefix: Icons.waves,
                    validate: (value) {
                      if (value!.isEmpty)
                        return 'Trihalomethanes must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: turbidityController,
                    text: 'Turbidity',
                    enable: isEnabled,
                    prefix: Icons.remove_red_eye,
                    validate: (value) {
                      if (value!.isEmpty) return 'Turbidity must not be empty';
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
                          final ph = double.parse(phController.text);
                          final solid = double.parse(solidController.text);
                          final hardness =
                              double.parse(hardnessController.text);
                          final chioramines =
                              double.parse(chioraminesController.text);
                          final sultfate =
                              double.parse(sultfateController.text);
                          final conductivity =
                              double.parse(conductivityController.text);
                          final organicCarbon =
                              double.parse(organicCarbonController.text);
                          final trihalomethanes =
                              double.parse(trihalomethanesController.text);
                          final turbidity =
                              double.parse(turbidityController.text);

                          setState(() {
                            isLoading = true;
                            isEnabled = false;
                          });

                          await sendPredictionRequest(
                              ph,
                              hardness,
                              solid,
                              chioramines,
                              sultfate,
                              conductivity,
                              organicCarbon,
                              trihalomethanes,
                              turbidity);

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
      double ph,
      double hardness,
      double solid,
      double chioramines,
      double sultfate,
      double conductivity,
      double organicCarbon,
      double trihalomethanes,
      double hturbidity) async {
      final apiUrl = 'https://watermanagement-b6i3.onrender.com/potability';

    try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Constants.userToken}'
      },
      body: jsonEncode({
        'ph': ph,
        'Hardness': hardness,
        'Solids': solid,
        'Chloramines': chioramines,
        'Sulfate': sultfate,
        'Conductivity': conductivity,
        'Organic_carbon': organicCarbon,
        'Trihalomethanes': trihalomethanes,
        'Turbidity': hturbidity,
      }),
    );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);

        // Assuming your API response contains a 'result' field
        double result = responseData['output'].toDouble();

        // Update the UI with the result
        setState(() {
          if (result > 0.5) {
            predictionResult = "Water is potable";
          }else {
            predictionResult = "Water is not potable";
          }
        });
        // This triggers a UI rebuild
        showResultDialog(true, '');
      } else {
        print('API request failed with status: ${response.statusCode}');
        showResultDialog(false, 'Prediction not found. Please check your input and try again.');
      }
    } catch (e) {
      print('An exception occured: $e');
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