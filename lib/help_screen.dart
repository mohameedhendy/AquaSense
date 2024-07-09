import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white10,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to AquaSence!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '1. Sign Up and Login:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Create an account or log in to access the features.'),
            SizedBox(height: 16),
            Text(
              '2. Dashboard:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('View your past and current water consumption, updated every minute.'),
            Text('Add goals using the button in the bottom-right corner.'),
            SizedBox(height: 16),
            Text(
              '3. News:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Explore news and tips about water.'),
            SizedBox(height: 16),
            Text(
              '4. Forecasting:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Predict potability, water level, leak detection, consumption, and quality.'),
            Text('See real-time dashboard updates when predicting consumption.'),
            SizedBox(height: 16),
            Text(
              '5. Maps:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Explore water sources around you.'),
            Text('Add new sources and pins on the map by long press on location.'),
            Text('Add new water source in your location with the button in the middle-bottom.')
          ],
        ),
      ),
    );
  }
}