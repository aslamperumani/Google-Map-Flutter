import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: const LatLng(10.053665734140834, 76.48126630680247),
    zoom: 15.4746,
  );

  static final CameraPosition _kLake = const CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(10.00555055299653, 76.34581741423942),
      tilt: 20,
      zoom: 36);

  MapType _defaultMapType = MapType.normal;

  void _changeMapType() {
    setState(() {
      _defaultMapType = _defaultMapType == MapType.normal ? MapType.satellite : MapType.normal;
      _defaultMapType = _defaultMapType == MapType.satellite ? MapType.terrain : MapType.satellite;
      _defaultMapType = _defaultMapType == MapType.terrain ? MapType.hybrid : MapType.terrain;
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(
        title: Text('Maps'),
        elevation: 10,
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      
      body: Stack(
        children: [
          GoogleMap(
          mapType: _defaultMapType,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),


          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 100, left: 15),
              child: Column(
                  children: <Widget>[
                    FloatingActionButton(
                        child: Icon(Icons.layers),
                        elevation: 5,
                        backgroundColor: Colors.deepPurple,
                        onPressed: () {
                          _changeMapType();
                        }),
                  ]),
            ),
      ],
          ),

      ],
      ),





      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('Find! Luminar', style: TextStyle(color: Color.fromRGBO(118, 74, 188, 1))),
        icon: const Icon(Icons.location_on, color: Color.fromRGBO(118, 74, 188, 1)),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        hoverColor: Color.fromRGBO(118, 74, 188, 1),
        elevation: 10,

      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}