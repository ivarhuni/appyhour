import 'dart:convert';

import 'package:happyhour_app/infrastructure/dto/bar_dto.dart';
import 'package:http/http.dart' as http;

/// HTTP client for fetching bars data from GitHub Pages.
class BarsApiClient {
  static const String _baseUrl = 'https://ivarhuni.github.io/appyhour';
  static const String _barsEndpoint = '/data/bars.json';

  final http.Client _httpClient;

  BarsApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  /// Fetch all bars from the API.
  /// Throws [BarsApiException] if the request fails.
  Future<BarsResponse> fetchBars() async {
    final uri = Uri.parse('$_baseUrl$_barsEndpoint');

    try {
      final response = await _httpClient.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return BarsResponse.fromJson(json);
      } else if (response.statusCode == 404) {
        throw const BarsApiException(
          'Bars data not found. Please try again later.',
        );
      } else {
        throw BarsApiException(
          'Failed to load bars. Status code: ${response.statusCode}',
        );
      }
    } on FormatException {
      throw const BarsApiException('Invalid data format received from server.');
    } on http.ClientException catch (e) {
      throw BarsApiException('Network error: ${e.message}');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}

/// Exception thrown when the bars API request fails.
class BarsApiException implements Exception {
  final String message;

  const BarsApiException(this.message);

  @override
  String toString() => message;
}
