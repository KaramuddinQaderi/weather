class WeatherModel {
  String? location, description, icon;
  dynamic temperature, feelslike, humidity, wind;

  WeatherModel({
    this.location,
    this.description,
    this.icon,
    this.temperature,
    this.feelslike,
    this.humidity,
    this.wind,
  });
}
