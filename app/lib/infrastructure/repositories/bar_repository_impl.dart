import 'package:happyhour_app/domain/entities/bar.dart';
import 'package:happyhour_app/domain/repositories/bar_repository.dart';
import 'package:happyhour_app/infrastructure/api/bars_api_client.dart';

/// Concrete implementation of [BarRepository].
/// Fetches bars from the GitHub Pages JSON endpoint.
class BarRepositoryImpl implements BarRepository {
  final BarsApiClient _apiClient;

  BarRepositoryImpl({BarsApiClient? apiClient})
    : _apiClient = apiClient ?? BarsApiClient();

  @override
  Future<List<Bar>> getAllBars() async {
    final response = await _apiClient.fetchBars();
    return response.bars.map((dto) => dto.toDomain()).toList();
  }
}
