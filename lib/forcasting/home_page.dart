import 'package:final_water_managment/forcasting/tank1.dart';
import 'package:flutter/material.dart';
import 'package:final_water_managment/forcasting/water_leak_detection/home_water_leak_detection.dart';
import 'package:final_water_managment/forcasting/water_level_Prediction.dart';
import 'package:final_water_managment/forcasting/water_potability_prediction.dart';
import 'package:final_water_managment/forcasting/water_quailty.dart';

class ForecastingHomePage extends StatelessWidget {
  final List<String> textList = [
    'Water Potability\n Prediction',
    'Water Level\n Prediction',
    'Water Leak\n Detection',
    'Predict Water\n Consumption',
    'Water Quality',
  ];

  final List<Widget> pagesList = [
    WaterPotabilityPrediction(),
    WaterLevelPrediction(),
    WaterLeakDetection(),
    Tank(),
    WaterQuality(),
  ];

  final List<IconData> iconList = [
    Icons.check_circle, // Customize the icons here
    Icons.opacity,
    Icons.error,
    Icons.show_chart,
    Icons.assessment,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forecasting', style: TextStyle(color: Colors.black),),
        elevation: 0,
        backgroundColor: Colors.white10,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: GridView.builder(
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: pagesList.length,
          itemBuilder: (BuildContext context, int index) {
            return buildWaterCard(context, index, iconList[index]);
          },
        ),
      ),
    );
  }

  Widget buildWaterCard(context, index, IconData iconData) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => pagesList[index],
        ),
      ),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 48.0,
              color: Colors.blue,
            ),
            SizedBox(height: 8.0),
            Text(
              textList[index],
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}