# Image Cache Configuration Contract

**File**: `app/lib/infrastructure/core/services/image_cache_service.dart`

## Purpose

Defines the configuration for the image caching system that stores network images locally with a 10-day lifetime.

## Configuration Schema

```dart
class ImageCacheService {
  static const String cacheKey = 'happyHourImageCache';
  
  static final CacheManager cacheManager = CacheManager(
    Config(
      cacheKey,
      stalePeriod: const Duration(days: 10),
      maxNrOfCacheObjects: 200,
      repo: JsonCacheInfoRepository(databaseName: cacheKey),
      fileService: HttpFileService(),
    ),
  );
}
```

## Configuration Fields

| Field | Type | Value | Constraint |
|-------|------|-------|------------|
| `cacheKey` | `String` | `"happyHourImageCache"` | Unique identifier |
| `stalePeriod` | `Duration` | `10 days` | **MUST be exactly 10 days** (FR-007) |
| `maxNrOfCacheObjects` | `int` | `200` | Maximum cached images |
| `repo` | `CacheInfoRepository` | JSON-backed | Persistence for cache metadata |
| `fileService` | `FileService` | HTTP | Network fetch implementation |

## Usage Contract

### Widget Usage

```dart
CachedNetworkImage(
  cacheManager: ImageCacheService.cacheManager,
  imageUrl: imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### Cache Operations

```dart
// Pre-cache an image
await ImageCacheService.cacheManager.downloadFile(url);

// Clear entire cache
await ImageCacheService.cacheManager.emptyCache();

// Remove specific URL
await ImageCacheService.cacheManager.removeFile(url);

// Get cached file info
final fileInfo = await ImageCacheService.cacheManager.getFileFromCache(url);
```

## Behavioral Contract

### Cache Hit
1. Image URL requested
2. Cache manager checks local storage
3. If file exists AND `validTill > DateTime.now()`: return cached file
4. Display image from cache (< 100ms)

### Cache Miss
1. Image URL requested
2. Cache manager checks local storage
3. If file missing OR expired: fetch from network
4. Store response with `validTill = now + 10 days`
5. Display fetched image

### Cache Eviction
When `maxNrOfCacheObjects` exceeded:
1. Sort cached items by `touched` (last access time)
2. Remove least recently used items until under limit

## Storage Location

| Platform | Path |
|----------|------|
| Android | `{app_dir}/cache/happyHourImageCache/` |
| iOS | `{app_dir}/Library/Caches/happyHourImageCache/` |
| Web | IndexedDB |

## Constraints

- Cache lifetime MUST be exactly 10 days (per FR-007)
- Cache MUST survive app restarts (persistent storage)
- Cache MUST be clearable by user (device settings)
- Corrupted cache entries MUST fallback to network fetch

