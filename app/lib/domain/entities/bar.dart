import 'package:equatable/equatable.dart';
import 'package:happyhour_app/domain/value_objects/happy_hour_days.dart';
import 'package:happyhour_app/domain/value_objects/happy_hour_time.dart';

/// Domain entity for a bar/restaurant with happy hour information.
/// Immutable value object with computed properties.
class Bar extends Equatable {
  final int id;
  final String name;
  final String email;
  final String street;
  final double latitude;
  final double longitude;
  final HappyHourDays happyHourDays;
  final HappyHourTime happyHourTime;
  final int cheapestBeerPrice; // ISK
  final int cheapestWinePrice; // ISK
  final bool twoForOne;
  final String notes;
  final String? description;
  final double? rating;

  // Computed at runtime (not persisted)
  final double? distanceFromUser; // meters, null if location unavailable

  const Bar({
    required this.id,
    required this.name,
    required this.email,
    required this.street,
    required this.latitude,
    required this.longitude,
    required this.happyHourDays,
    required this.happyHourTime,
    required this.cheapestBeerPrice,
    required this.cheapestWinePrice,
    required this.twoForOne,
    required this.notes,
    this.description,
    this.rating,
    this.distanceFromUser,
  });

  /// Check if happy hour is currently active
  bool isHappyHourActive([DateTime? time]) {
    final now = time ?? DateTime.now();
    return happyHourDays.isActiveOn(now.weekday) &&
        happyHourTime.isActiveAt(now);
  }

  /// Create a copy with updated distance
  Bar copyWith({
    int? id,
    String? name,
    String? email,
    String? street,
    double? latitude,
    double? longitude,
    HappyHourDays? happyHourDays,
    HappyHourTime? happyHourTime,
    int? cheapestBeerPrice,
    int? cheapestWinePrice,
    bool? twoForOne,
    String? notes,
    String? description,
    double? rating,
    double? distanceFromUser,
  }) {
    return Bar(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      street: street ?? this.street,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      happyHourDays: happyHourDays ?? this.happyHourDays,
      happyHourTime: happyHourTime ?? this.happyHourTime,
      cheapestBeerPrice: cheapestBeerPrice ?? this.cheapestBeerPrice,
      cheapestWinePrice: cheapestWinePrice ?? this.cheapestWinePrice,
      twoForOne: twoForOne ?? this.twoForOne,
      notes: notes ?? this.notes,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      distanceFromUser: distanceFromUser ?? this.distanceFromUser,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    street,
    latitude,
    longitude,
    happyHourDays,
    happyHourTime,
    cheapestBeerPrice,
    cheapestWinePrice,
    twoForOne,
    notes,
    description,
    rating,
    distanceFromUser,
  ];
}
