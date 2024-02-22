import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/components/error.dart';
import 'package:weather/components/loading_widget.dart';
import 'package:weather/models/weather_models.dart';
import 'package:weather/services/location.dart';
import 'package:weather/services/networking.dart';
import 'package:weather/services/weather.dart';
import 'package:weather/utilities/constants.dart';
import 'package:weather/utilities/weather-icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDataLoaded = false;
  bool isErroe = false;
  double? latitude, longitude;
  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  LocationPermission? permission;
  WeatherModel? weatherModel;
  int code = 0;
  Weather weather = Weather();
  var weatherData;
  String? title, message;

  @override
  void initState() {
    super.initState();
    getPermission();
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
          updateUI();
        }
      } else {
        print('User denied the request');
      }
    } else {
      updateUI();
    }
  }

  void updateUI({String? cityName}) async {
    weatherData = null;
    if (cityName == null || cityName == '') {
      if (!await geolocatorPlatform.isLocationServiceEnabled()) {
        setState(() {
          isErroe = true;
          isDataLoaded = true;
          title = 'Location is turned off!';
          message = 'Please enable the your location*';
          return;
        });
      }
      weatherData = await weather.getLocationWeather();
    } else {
      weatherData = await weather.getCityWeather(cityName);
    }

    code = weatherData['weather'][0]['id'];
    weatherModel = WeatherModel(
      location: weatherData['name'] + ', ' + weatherData['sys']['country'],
      description: weatherData['weather'][0]['description'],
      temperature: weatherData['main']['temp'],
      feelslike: weatherData['main']['feels_like'],
      humidity: weatherData['main']['humidity'],
      wind: weatherData['wind']['speed'],
      icon:
          'images/weather-icons/${getIconPrefix(code)}${kWeatherIcons[code.toString()]!['icon']}.svg',
    );
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded) {
      return LoadingWidget();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        decoration: kTextFieldDecoration,
                        onSubmitted: (String typedName) {
                          isDataLoaded = false;
                          updateUI(cityName: typedName);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white12,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isDataLoaded = false;
                            getPermission();
                          });
                        },
                        child: Container(
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              Text(
                                'My Location',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white60,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                Icons.gps_fixed,
                                color: Colors.white60,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              isErroe
                  ? ErrorMessage(title: title!, message: message!)
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.location_city_rounded,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                weatherModel!.location!,
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          SvgPicture.asset(
                            weatherModel!.icon!,
                            height: 280,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            '${weatherModel!.temperature!.round()}°',
                            style: TextStyle(
                              fontSize: 80,
                            ),
                          ),
                          Text(weatherModel!.description!.toUpperCase()),
                        ],
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              '${weatherModel != null ? weatherModel!.feelslike!.round() : 0}°',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'FEELS LIKE',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: VerticalDivider(
                            thickness: 1,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              '${weatherModel != null ? weatherModel!.humidity!.round() : 0}%',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'HUMIDITY',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: VerticalDivider(
                            thickness: 1,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              '${weatherModel != null ? weatherModel!.wind!.round() : 0}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'WIND',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
