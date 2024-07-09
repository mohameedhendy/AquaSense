import 'dart:convert';
import 'dart:io';
import 'package:final_water_managment/shared/components.dart';
import 'package:final_water_managment/shared/constant.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WaterQuality extends StatefulWidget {
  @override
  State<WaterQuality> createState() => _WaterQualityState();
}

class _WaterQualityState extends State<WaterQuality> {
  var formKey = GlobalKey<FormState>();

  var ammoniaController = TextEditingController();
  var arsenicController = TextEditingController();
  var bariumController = TextEditingController();
  var chloramineController = TextEditingController();
  var chromiumController = TextEditingController();
  var copperController = TextEditingController();
  var flourideController = TextEditingController();
  var bacteriaController = TextEditingController();
  var leadController = TextEditingController();
  var nitratesController = TextEditingController();
  var nitritesController = TextEditingController();
  var mercuryController = TextEditingController();
  var perchlorateController = TextEditingController();
  var radiumController = TextEditingController();
  var seleniumController = TextEditingController();
  var silverController = TextEditingController();
  var uraniumController = TextEditingController();
  String predictionResult = '';
  bool isLoading = false;
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Water Quality', style: TextStyle(color: Colors.black),),
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
                    controller: ammoniaController,
                    text: 'Ammonia',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Ammonia must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: arsenicController,
                    text: 'Arsenic',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Arsenic must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: bariumController,
                    text: 'Barium',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Barium must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: chloramineController,
                    text: 'Chloramine',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Chloramine must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: chromiumController,
                    text: 'Chromium',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Chromium must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: copperController,
                    text: 'Copper',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Copper must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: flourideController,
                    text: 'Flouride',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Flouride must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: bacteriaController,
                    text: 'Bacteria',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Bacteria must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: leadController,
                    text: 'Lead',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Lead must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: nitratesController,
                    text: 'Nitrates',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Nitrates must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: nitritesController,
                    text: 'Nitrites',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Nitrites must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: mercuryController,
                    text: 'Mercury',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Mercury must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: perchlorateController,
                    text: 'Perchlorate',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty)
                        return 'Perchlorate must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: radiumController,
                    text: 'Radium',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'rRdium must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: seleniumController,
                    text: 'Selenium',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Selenium must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: silverController,
                    text: 'Silver',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Silver must not be empty';
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  defaultFormField(
                    controller: uraniumController,
                    text: 'Uranium',
                    enable: isEnabled,
                    validate: (value) {
                      if (value!.isEmpty) return 'Uranium must not be empty';
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
                        final ammonia = ammoniaController.text;
                        final arsenic = arsenicController.text;
                        final barium = bariumController.text;
                        final chloramine = chloramineController.text;
                        final chromium = chromiumController.text;
                        final copper = copperController.text;
                        final flouride = flourideController.text;
                        final bacteria = bacteriaController.text;
                        final lead = leadController.text;
                        final nitrates = nitratesController.text;
                        final nitrites = nitritesController.text;
                        final mercury = mercuryController.text;
                        final perchlorate = perchlorateController.text;
                        final radium = radiumController.text;
                        final selenium = seleniumController.text;
                        final silver = silverController.text;
                        final uranium = uraniumController.text;
                        final is_safe = '0';

                        setState(() {
                          isLoading = true;
                          isEnabled = false;
                        });

                        await sendPredictionRequest(
                            ammonia,
                            arsenic,
                            barium,
                            chloramine,
                            chromium,
                            copper,
                            flouride,
                            bacteria,
                            lead,
                            nitrates,
                            nitrites,
                            mercury,
                            perchlorate,
                            radium,
                            selenium,
                            silver,
                            uranium,
                            is_safe
                        );

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
      String ammonia,
      String arsenic,
      String barium,
      String chloramine,
      String chromium,
      String copper,
      String flouride,
      String bacteria,
      String lead,
      String nitrates,
      String nitrites,
      String mercury,
      String perchlorate,
      String radium,
      String selenium,
      String silver,
      String uranium,
      String is_safe
      ) async {
    final apiUrl = 'http://192.168.10.63:2100/predict';

    try{
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.userToken}'
        },
        body: jsonEncode({
          'ammonia': ammonia,
          'arsenic': arsenic,
          'barium': barium,
          'chloramine': chloramine,
          'chromium': chromium,
          'copper': copper,
          'flouride': flouride,
          'bacteria': bacteria,
          'lead': lead,
          'nitrates': nitrates,
          'nitrites': nitrites,
          'mercury': mercury,
          'perchlorate': perchlorate,
          'radium': radium,
          'selenium': selenium,
          'silver': silver,
          'uranium': uranium,
          'is_safe': 0,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);

        double aluminum = responseData['predictions']['aluminum'];
        double cadmium = responseData['predictions']['cadmium'];
        String result = responseData['result'];

        if (aluminum <= 2.8 && cadmium <= 0.005) {
          predictionResult = result;
        } else if (aluminum > 2.8 && cadmium <= 0.005) {
          predictionResult = "$result. you need to reduce aluminum value";
        } else if (aluminum <= 2.8 && cadmium > 0.005) {
          predictionResult = "$result. you need to reduce cadmium value";
        } else {
          predictionResult = "$result. you need to reduce aluminum and cadmium values";
        }

        setState(() {
          predictionResult = predictionResult;
        });

        showResultDialog(true, '');
      } else {
        if (response.statusCode == 500) {
          // Handle 500 Not Found error
          print('API request failed with status: ${response.statusCode}');
          showResultDialog(false,
              'Prediction not found. Please check your input and try again.');
        } else {
          // Handle other status codes
          print('API request failed with status: ${response.statusCode}');
          showResultDialog(
              false, 'Failed to fetch prediction. Please try again.');
        }
      }
    } catch (e) {
      // Check for specific exceptions to provide more accurate error messages
      if (e is SocketException) {
        showResultDialog(false, 'An error occurred. Please check your internet connection and try again.', socketException: e);
      } else {
        print('An error occurred: $e');
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
}