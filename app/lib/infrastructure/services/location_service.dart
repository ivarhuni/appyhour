import 'package:geolocator/geolocator.dart';
import 'package:happyhour_app/domain/entities/bar.dart';

/// Service for handling location-related functionality.
class LocationService {
  /// Check if location services are enabled and permission is granted.
  Future<LocationPermissionStatus> checkPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionStatus.serviceDisabled;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationPermissionStatus.denied;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionStatus.deniedForever;
    }

    return LocationPermissionStatus.granted;
  }

  /// Get the current user position.
  Future<Position?> getCurrentPosition() async {
    try {
      final status = await checkPermission();
      if (status != LocationPermissionStatus.granted) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (e) {
      return null;
    }
  }

  /// Calculate distance between user position and a bar.
  double calculateDistance(
    Position userPosition,
    double barLatitude,
    double barLongitude,
  ) {
    return Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      barLatitude,
      barLongitude,
    );
  }

  /// Update bars with distance from user position.
  List<Bar> updateBarsWithDistance(List<Bar> bars, Position userPosition) {
    return bars.map((bar) {
      final distance = calculateDistance(
        userPosition,
        bar.latitude,
        bar.longitude,
      );
      return bar.copyWith(distanceFromUser: distance);
    }).toList();
  }
}

/// Status of location permission.
enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}
