import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/services/location.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  LocationPermission? permission;

  @override
  void initState() {
    super.initState();
    getPermission();
  }
  
  void getData() async {
   http.Response response = await http.get(Uri.parse("{"coord":{"lon":10.99,"lat":44.34},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"base":"stations","main":{"temp":284.41,"feels_like":284.02,"temp_min":283.12,"temp_max":287.03,"pressure":1014,"humidity":93,"sea_level":1014,"grnd_level":928},"visibility":10000,"wind":{"speed":0.84,"deg":68,"gust":1.75},"clouds":{"all":93},"dt":1683909166,"sys":{"type":2,"id":2044440,"country":"IT","sunrise":1683863580,"sunset":1683916314},"timezone":7200,"id":3163858,"name":"Zocca","cod":200}"););
   print(response);
  }

  void getPermission() async {
    permission = await geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      print('Permission denied');
      permission = await geolocatorPlatform.requestPermission();
      if (permission != LocationPermission.denied) {
        if (permission == LocationPermission.deniedForever) {
          print(
              'Permission permannently denied, please provide permission to the app from device setting');
        } else {
          print('Permission granted');
          getLocation();
        }
      } else {
        print('User denied the request');
      }
    } else {
      getLocation();
    }
  }

  void getLocation() async {
    Location location = Location();
    await location.gerCurrentLocation();
    print(location.latitude);
    print(location.longitude);
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      body: SafeArea(
        child: Center(),
      ),
    );
  }
}
