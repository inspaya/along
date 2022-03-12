import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'addressToLocation.dart';

void main() {
  runApp(Along());
}

class Along extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapView(),
    );
  }
}

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  late double lat;
  late double lng;

  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(8.8219003, 7.5709147), zoom: 14.8);

  void _getLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    //print(_locationData.latitude.toString());

    _locationData = await location.getLocation();
    lat = _locationData.latitude!;
    lng = _locationData.longitude!;
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 18.0,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    AddressToLocation location1 = AddressToLocation();
    var address;

    return SizedBox(
      height: height,
      width: width,
      child: Scaffold(
        body: Stack(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Enter Address'),
              onChanged: (value) async {
                address = value;
              },
            ),
            TextButton(
                onPressed: () {
                  var myLocation =
                      location1.getAddress('Gronausestraat 710, Enschede');
                  setState(() {
                    var lat = AddressToLocation.lat;
                    var lng = AddressToLocation.lng;
                    mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(lat, lng),
                          zoom: 18.0,
                        ),
                      ),
                    );
                  });
                },
                child: Text('Search'))
          ],
        ),
      ),
    );
  }
}
