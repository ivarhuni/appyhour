import 'package:happyhour_app/domain/bars/entities/bar.dart';
import 'package:happyhour_app/infrastructure/bars/api/bars_api_client.dart';
import 'package:happyhour_app/infrastructure/bars/repository/i_bar_repository.dart';

/// Concrete implementation of [IBarRepository].
/// Fetches bars from the GitHub Pages JSON endpoint.
class BarRepository implements IBarRepository {
  final BarsApiClient _apiClient;

  BarRepository({BarsApiClient? apiClient})
    : _apiClient = apiClient ?? BarsApiClient();

  @override
  Future<List<Bar>> getAllBars() async {
    try {
      final response = await _apiClient.fetchBars();
      return response.bars.map((dto) => dto.toDomain()).toList();
    } on BarsApiException catch (e) {
      throw BarRepositoryException(e.message);
    }
  }
}
