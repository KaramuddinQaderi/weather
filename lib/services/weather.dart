import 'package:weather/services/location.dart';
import 'package:weather/services/networking.dart';
import 'package:weather/utilities/constants.dart';

class Weather {
  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.gerCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
      "$openWeatherMapURL?units=metric&lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric",
    );
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getCityWeather(String cityName) async {
    NetworkHelper networkHelper = NetworkHelper(
      '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=metric',
    );
    var weatherData = await networkHelper.getData();
    return weatherData;
  }
}
