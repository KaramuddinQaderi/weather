import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude, longitude;

  Future<void> gerCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
    latitude = position.latitude;
    longitude = position.longitude;
  }
}
