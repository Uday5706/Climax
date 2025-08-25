import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude;
  double? longitude;

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      print('Location services are disabled.');
      return;
    }

    // 2. Check permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied.');
        return;
      }
    }

    // 3. Handle "Denied Forever"
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      print('Location permission permanently denied.');
      return;
    }

    // 4. Get the location (new settings API)
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0, // update for every movement
      ),
    );

    latitude = position.latitude;
    longitude = position.longitude;

    print('Latitude: $latitude, Longitude: $longitude');
  }
}
