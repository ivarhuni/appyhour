import 'package:happyhour_app/domain/bars/entities/bar.dart';

/// Abstract interface for bar data access.
/// Implemented by infrastructure layer.
abstract class IBarRepository {
  /// Fetch all bars from the data source.
  /// Throws [BarRepositoryException] if the fetch fails.
  Future<List<Bar>> getAllBars();
}

/// Exception thrown when bar repository operations fail.
class BarRepositoryException implements Exception {
  final String message;

  const BarRepositoryException(this.message);

  @override
  String toString() => message;
}
