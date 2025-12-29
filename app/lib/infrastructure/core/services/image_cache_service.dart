import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Service providing a configured cache manager for network images.
///
/// The cache has a 10-day stale period and stores up to 200 images.
class ImageCacheService {
  /// Unique key for the image cache.
  static const String cacheKey = 'happyHourImageCache';

  /// Singleton cache manager instance with 10-day stale period.
  static final CacheManager cacheManager = CacheManager(
    Config(
      cacheKey,
      stalePeriod: const Duration(days: 10),
      maxNrOfCacheObjects: 200,
    ),
  );
}
