/// Enum representing sort options.
enum SortPreference {
  /// Default: JSON order (server-controlled)
  serverOrder,

  /// Cheapest beer price ascending
  beerPrice,

  /// Distance from user (nearest first)
  distance,

  /// Rating descending (if available)
  rating,
}
