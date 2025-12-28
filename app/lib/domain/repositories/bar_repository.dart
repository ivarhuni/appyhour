import 'package:happyhour_app/domain/entities/bar.dart';

/// Abstract interface for bar data access.
/// Implemented by infrastructure layer.
abstract class BarRepository {
  /// Fetch all bars from the data source.
  /// Throws an exception if the fetch fails.
  Future<List<Bar>> getAllBars();
}
