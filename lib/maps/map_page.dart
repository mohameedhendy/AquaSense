import 'dart:async';
import 'dart:convert';
import 'package:final_water_managment/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver, AutomaticKeepAliveClientMixin{
  GoogleMapController? _controller;
  Set<Marker> _userPinsMarkers = Set<Marker>();
  Set<Marker> _allPinsMarkers = Set<Marker>();
  BitmapDescriptor? redMarkerIcon;

  int _currentIndex = 0;

  Marker? _currentLocationMarker;
  String? pinId;
  String? newTitle;
  LatLng? userLocation;

  Set<LatLng> _previousPinLocations = Set<LatLng>();

  TextEditingController _pinTitleController = TextEditingController();

  Timer? _locationUpdateTimer;

  // Add the line below to preserve the state
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _createCustomMarkerIcons();
    Constants.fetchUserToken();
    _initializeMap();

    // Add this class as an observer to listen for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
    _loadPreviousPinLocations();
  }

  @override
  void dispose() {
    // Cancel the timer to avoid calling setState after the widget is disposed
    _locationUpdateTimer?.cancel();

    // Dispose of the GoogleMapController
    _controller?.dispose();

    // Remove this class as an observer when the widget is disposed
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  void _initializeMap() async {
    await _getCurrentLocation(); // Initial location fetch

    // Set up a periodic timer for continuous updates
    _locationUpdateTimer = Timer.periodic(Duration(seconds: 10), (Timer timer) async {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        // Check if the widget is still mounted before calling setState
        setState(() {
          userLocation = LatLng(position.latitude, position.longitude);
        });
      }
    });

    _fetchAndDisplayMyPins();
  }

  // Function to create custom marker icons with different colors
  void _createCustomMarkerIcons() {
    redMarkerIcon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  }

  // Method to handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Reload previous pin locations when the app is resumed
      _loadPreviousPinLocations();
      _initializeMap();
    } else if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      // Dispose of the resources when the app is inactive or paused
      _locationUpdateTimer?.cancel();
    }
  }

  Future<void> _getCurrentLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      userLocation = LatLng(position.latitude, position.longitude);
      print(userLocation);

      _controller!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: userLocation!, zoom: 15.0),
      ));
    } else if (status.isDenied) {
      Fluttertoast.showToast(
        msg: 'Location permission is required for this feature.',
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _postUserPin(LatLng location, String title) async {
    TextEditingController titleController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Pin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter a title for the pin:'),
              TextField(
                controller: titleController,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                newTitle = titleController.text.isNotEmpty
                    ? titleController.text
                    : 'Water source';
                Navigator.of(context).pop(); // Close the dialog

                try {
                  final apiUrl =
                      'https://watermanagement-b6i3.onrender.com/map/mypins';
                  final response = await http.post(
                    Uri.parse(apiUrl),
                    headers: {
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer ${Constants.userToken}',
                    },
                    body: jsonEncode({
                      'title' : newTitle,
                      'X_axis': location.latitude,
                      'Y_axis': location.longitude,
                    }),
                  );

                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    Fluttertoast.showToast(
                      msg: 'Pin added successfully.',
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                    );
                    _fetchAndDisplayMyPins(); // Refresh pins after adding a new one
                    // Parse the response body to get the pinId
                    final Map<String, dynamic> responseData =
                    json.decode(response.body);
                    pinId = responseData['id'].toString();
                  } else {
                    print('Error posting user pin: ${response.statusCode}');
                    final Map<String, dynamic> errorResponse =
                    json.decode(response.body);
                    print('Error message: ${errorResponse['message']}');
                    print(Constants.userToken);
                    Fluttertoast.showToast(
                      msg: 'Failed to add pin. Please try again.',
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }
                } catch (exception) {
                  print('Exception posting user pin: $exception');
                  Fluttertoast.showToast(
                    msg: 'Failed to add pin. Please try again.',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchAndDisplayMyPins() async {
    try {
      final apiUrl = 'https://watermanagement-b6i3.onrender.com/map/mypins';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.userToken}'
        },
      );

      if (response.statusCode == 200) {
        dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('pins')) {
          List<dynamic> pinsData = responseData['pins'];

          _userPinsMarkers
              .clear(); // Clear existing markers before adding new ones

          for (var pinData in pinsData) {
            double? latitude = (pinData['X_axis'] as num?)?.toDouble();
            double? longitude = (pinData['Y_axis'] as num?)?.toDouble();
            newTitle = pinData['title'];
            String pinId = pinData['id']
                .toString(); // Assuming your API returns a unique identifier for each pin

            if (latitude != null && longitude != null) {
              LatLng pinLocation = LatLng(latitude, longitude);
              _addMarker(
                  pinLocation, newTitle!, redMarkerIcon!, 'user_pin',
                  pinId);
            } else {
              print(
                  'Latitude or longitude is null or not a valid double for pin data: $pinData');
            }
          }
        } else {
          print('Invalid response format or missing "pins" key.');
        }
      } else {
        print('Error fetching user pins: ${response.statusCode}');
      }
    } catch (exception) {
      print('Exception fetching user pins: $exception');
    }
  }

  Future<void> _fetchAllPins() async {
    try {
      final apiUrl = 'https://watermanagement-b6i3.onrender.com/map/allpins';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.userToken}'
        },
      );

      if (response.statusCode == 200) {
        dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('pins')) {
          List<dynamic> pinsData = responseData['pins'];

          _allPinsMarkers
              .clear(); // Clear existing markers before adding new ones

          for (var pinData in pinsData) {
            double? latitude = (pinData['X_axis'] as num?)?.toDouble();
            double? longitude = (pinData['Y_axis'] as num?)?.toDouble();
            newTitle = pinData['title'];

            if (latitude != null && longitude != null) {
              LatLng pinLocation = LatLng(latitude, longitude);
              _addMarker(pinLocation, newTitle!, redMarkerIcon!, 'all_pin',
                  pinId);
            } else {
              print(
                  'Latitude or longitude is null or not a valid double for pin data: $pinData');
            }
          }
        } else {
          print('Invalid response format or missing "pins" key.');
        }
      } else {
        print('Error fetching all pins: ${response.statusCode}');
      }
    } catch (exception) {
      print('Exception fetching all pins: $exception');
    }
  }

  void _addMarker(LatLng location, String title, BitmapDescriptor icon, String markerIdValue, String? pinId) {
    final Marker newMarker = Marker(
      markerId: MarkerId('$markerIdValue${location.toString()}'),
      position: location,
      infoWindow: InfoWindow(
        title: newTitle,
        snippet: (markerIdValue == 'user_pin') ? 'Delete' : null,
        onTap: () {
          // Check if the tapped marker is a user pin
          if (markerIdValue == 'user_pin') {
            // Show a dialog with a delete confirmation
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Delete Pin'),
                  content: Text('Are you sure you want to delete this pin?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        _deleteUserPin(pinId!, location); // Delete the pin
                        Navigator.of(context).pop();
                      },
                      child: Text('Delete'),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      icon: icon,
    );

    setState(() {
      if (markerIdValue == 'current_location') {
        _currentLocationMarker = newMarker;
      } else if (markerIdValue == 'user_pin') {
        _userPinsMarkers.add(newMarker);
      } else if (markerIdValue == 'all_pin') {
        _allPinsMarkers.add(newMarker);
      }
    });
  }

  Future<void> _deleteUserPin(String pinId, LatLng location) async {
    try {
      final apiUrl =
          'https://watermanagement-b6i3.onrender.com/map/mypin/${location.latitude}/${location.longitude}';
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.userToken}',
        },
      );

      if (response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: 'Pin deleted successfully.',
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // Remove the deleted location from the set of previous pin locations
        setState(() {
          _previousPinLocations.remove(location);
        });

        // Remove the corresponding marker from _userPinsMarkers
        setState(() {
          _userPinsMarkers.removeWhere(
                (marker) =>
            marker.position.latitude == location.latitude &&
                marker.position.longitude == location.longitude,
          );
        });

        // Save updated locations to shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setStringList(
          'previousLocations',
          _previousPinLocations
              .map((location) => '${location.latitude},${location.longitude}')
              .toList(),
        );

        _fetchAndDisplayMyPins(); // Refresh pins after deleting one
      } else {
        print('Error deleting user pin: ${response.statusCode}');
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        print('Error message: ${errorResponse['message']}');
        Fluttertoast.showToast(
          msg: 'Failed to delete pin. Please try again.',
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (exception) {
      print('Exception deleting user pin: $exception');
      Fluttertoast.showToast(
        msg: 'Failed to delete pin. Please try again.',
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }


  void _loadPreviousPinLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? previousLocations = prefs.getStringList('previousLocations');

    if (previousLocations != null) {
      print('Retrieved previousLocations: $previousLocations');

      // Convert saved locations to LatLng objects and store them in a Set
      Set<LatLng> previousLocationsSet = previousLocations
          .map((locationString) {
        List<String> coordinates = locationString.split(',');
        double latitude = double.parse(coordinates[0]);
        double longitude = double.parse(coordinates[1]);
        return LatLng(latitude, longitude);
      })
          .toSet();

      // Update _previousPinLocations set
      setState(() {
        _previousPinLocations = previousLocationsSet;
      });
    }
  }

  Future<void> _addPinAtCurrentLocation() async {
    if (userLocation != null) {
      // Check if the new pin location is in the set of previous pin locations
      if (_previousPinLocations.any((location) =>
          _areLocationsEqual(location, userLocation!))) {
        Fluttertoast.showToast(
          msg: 'You cannot set a pin in the same location again.',
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        // Show a confirmation dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm'),
              content: Text('Do you want to add a pin at your current location?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss the dialog
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(); // Dismiss the dialog
                    _postUserPin(userLocation!, 'New Pin');

                    // Add the new location to the set of previous pin locations
                    setState(() {
                      _previousPinLocations.add(userLocation!);
                    });

                    // Save updated locations to shared preferences
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setStringList(
                      'previousLocations',
                      _previousPinLocations
                          .map((location) =>
                      '${location.latitude},${location.longitude}')
                          .toList(),
                    );
                  },
                  child: Text('Add Pin'),
                ),
              ],
            );
          },
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Unable to determine current location.',
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  bool _areLocationsEqual(LatLng location1, LatLng location2) {
    const double epsilon = 1e-6; // Adjust epsilon as needed
    return (location1.latitude - location2.latitude).abs() < epsilon &&
        (location1.longitude - location2.longitude).abs() < epsilon;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map', style: TextStyle(color: Colors.black),),
        elevation: 0,
        backgroundColor: Colors.white10,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        // Show the default blue dot for current location
        myLocationButtonEnabled: true,
        // Show the my location button
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 12.0,
        ),
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
        markers: _currentIndex == 0
            ? _userPinsMarkers.union(
            _currentLocationMarker != null ? {_currentLocationMarker!} : {})
            : (_currentIndex == 1
            ? _allPinsMarkers
            : _userPinsMarkers.union(_currentLocationMarker != null
            ? {_currentLocationMarker!}
            : {})),
        onLongPress: (LatLng location) => _postUserPin(location, 'New Pin'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (_currentIndex == 0) {
              // Display user's pins
              _fetchAndDisplayMyPins();
            } else if (_currentIndex == 1) {
              // Display all pins
              _fetchAllPins();
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            label: 'My Pins',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'All Pins',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
        onPressed: () => _addPinAtCurrentLocation(),
        tooltip: 'Add Pin',
        child: Icon(Icons.add),
      )
          : null,
    );
  }
}