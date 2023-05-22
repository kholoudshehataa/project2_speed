
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double latitude = 0,
      longtiude = 0,
      lastLatitude = 0,
      lastLongtiude = 0,
      earthRadius = 6371.0,
      speed = 0;
  int lastTime = 0; // In kilometers
  Timer timer;
  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(const Duration(seconds: 30), (Timer t) => getLocation());
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Device Location Tutorial !!!")),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Latitude : $latitude"),
              SizedBox(
                height: 50,
              ),
              Text("Longitude : $longtiude"),
              SizedBox(
                height: 50,
              ),
              Text("Speed : $speed"),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getLocation() async {
    var location = new Location();
    try {
      await location.getLocation().then((onValue) {
        print("*****${onValue.latitude},${onValue.longitude}");
        if(onValue!=null)
        {
          setState(() {
            latitude = onValue.latitude.toDouble();
            longtiude = onValue.longitude.toDouble();
            speed = calculateDistance(
                latitude, longtiude, lastLatitude, lastLongtiude) / 30;
            speed=double.parse(speed.toStringAsFixed(4));
            lastLatitude = latitude;
            lastLongtiude = longtiude;
            print(("## Speed:$speed"));
          });

        }

      });
    } catch (e) {
      print(e);
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * asin(sqrt(a));

    final distance = earthRadius * c;
    return distance;
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180.0);
  }
}