// import 'package:dio/dio.dart';
// import 'package:final_water_managment/maps/directions_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class DirectionsRepository {
//   static const String _baseUrl =
//       'https://maps.googleapis.com/maps/api/directions/json?';
//
//   final Dio _dio;
//
//   DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();
//
//   Future<Directions> getDirections({
//     required LatLng origin,
//     required LatLng destination,
//   }) async {
//     final response = await _dio.get(
//       _baseUrl,
//       queryParameters: {
//         'origin': '${origin.latitude},${origin.longitude}',
//         'destination': '${destination.latitude},${destination.longitude}',
//         'key': 'AIzaSyCBK4nEPyNKqT9R8XXIWvZAUHQJ4DLDaRY',
//       },
//     );
//
//     // Check if response is successful
//     if (response.statusCode == 200) {
//       return Directions.fromMap(response.data);
//     }
//     return null!;
//   }
//
// }


// directions_repository.dart
import 'package:dio/dio.dart';
import 'package:final_water_managment/maps/directions_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;
  final void Function() onPolylineUpdated;

  DirectionsRepository({required this.onPolylineUpdated, Dio? dio})
      : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': 'AIzaSyCBK4nEPyNKqT9R8XXIWvZAUHQJ4DLDaRY', // Replace with your actual API key
        },
      );

      if (response.statusCode == 200) {
        return Directions.fromMap(response.data);
      }
    } catch (e) {
      print('Error getting directions: $e');
    }

    return null;
  }

}
