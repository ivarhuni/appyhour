import 'package:happyhour_app/domain/entities/bar.dart';
import 'package:happyhour_app/domain/value_objects/happy_hour_days.dart';
import 'package:happyhour_app/domain/value_objects/happy_hour_time.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bar_dto.g.dart';

@JsonSerializable()
class BarDto {
  final int id;
  final String name;
  final String email;
  final String street;
  final double latitude;
  final double longitude;
  @JsonKey(name: 'happy_hour_days')
  final String happyHourDays;
  @JsonKey(name: 'happy_hour_times')
  final String happyHourTimes;
  @JsonKey(name: 'cheapest_beer_price')
  final int cheapestBeerPrice;
  @JsonKey(name: 'cheapest_wine_price')
  final int cheapestWinePrice;
  @JsonKey(name: 'two_for_one')
  final bool twoForOne;
  final String notes;
  final String? description;
  final double? rating;

  const BarDto({
    required this.id,
    required this.name,
    required this.email,
    required this.street,
    required this.latitude,
    required this.longitude,
    required this.happyHourDays,
    required this.happyHourTimes,
    required this.cheapestBeerPrice,
    required this.cheapestWinePrice,
    required this.twoForOne,
    required this.notes,
    this.description,
    this.rating,
  });

  factory BarDto.fromJson(Map<String, dynamic> json) => _$BarDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BarDtoToJson(this);

  /// Convert DTO to domain entity
  Bar toDomain() {
    return Bar(
      id: id,
      name: name.isNotEmpty ? name : 'Unknown Bar',
      email: email,
      street: street,
      latitude: latitude,
      longitude: longitude,
      happyHourDays: HappyHourDays.parse(happyHourDays),
      happyHourTime: HappyHourTime.parse(happyHourTimes),
      cheapestBeerPrice: cheapestBeerPrice,
      cheapestWinePrice: cheapestWinePrice,
      twoForOne: twoForOne,
      notes: notes,
      description: description,
      rating: rating,
    );
  }
}

@JsonSerializable()
class BarsResponse {
  @JsonKey(name: 'generated_at')
  final String generatedAt;
  final int count;
  final List<BarDto> bars;

  const BarsResponse({
    required this.generatedAt,
    required this.count,
    required this.bars,
  });

  factory BarsResponse.fromJson(Map<String, dynamic> json) =>
      _$BarsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BarsResponseToJson(this);
}
