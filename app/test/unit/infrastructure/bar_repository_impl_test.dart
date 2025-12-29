import 'package:flutter_test/flutter_test.dart';
import 'package:happyhour_app/infrastructure/bars/api/bars_api_client.dart';
import 'package:happyhour_app/infrastructure/bars/dto/bar_dto.dart';
import 'package:happyhour_app/infrastructure/bars/repository/bar_repository.dart';
import 'package:happyhour_app/infrastructure/bars/repository/i_bar_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockBarsApiClient extends Mock implements BarsApiClient {}

void main() {
  late MockBarsApiClient mockApiClient;
  late BarRepository repository;

  const testBarsResponse = BarsResponse(
    generatedAt: '2024-01-01T00:00:00Z',
    count: 2,
    bars: [
      BarDto(
        id: 1,
        name: 'Test Bar 1',
        email: 'bar1@test.com',
        street: 'Street 1',
        latitude: 64.1,
        longitude: -21.9,
        happyHourDays: 'Every day',
        happyHourTimes: '15:00 - 17:00',
        cheapestBeerPrice: 800,
        cheapestWinePrice: 1000,
        twoForOne: false,
        notes: 'Note 1',
      ),
      BarDto(
        id: 2,
        name: 'Test Bar 2',
        email: 'bar2@test.com',
        street: 'Street 2',
        latitude: 64.2,
        longitude: -21.8,
        happyHourDays: 'Mon-Fri',
        happyHourTimes: '14:00 - 18:00',
        cheapestBeerPrice: 600,
        cheapestWinePrice: 900,
        twoForOne: true,
        notes: 'Note 2',
      ),
    ],
  );

  setUp(() {
    mockApiClient = MockBarsApiClient();
    repository = BarRepository(apiClient: mockApiClient);
  });

  group('BarRepository', () {
    group('getAllBars', () {
      test('returns list of domain Bar entities', () async {
        when(
          () => mockApiClient.fetchBars(),
        ).thenAnswer((_) async => testBarsResponse);

        final bars = await repository.getAllBars();

        expect(bars.length, 2);
        expect(bars[0].id, 1);
        expect(bars[0].name, 'Test Bar 1');
        expect(bars[0].happyHourDays.displayString, 'Every day');
        expect(bars[0].happyHourTime.displayString, '15:00 - 17:00');
        expect(bars[1].id, 2);
        expect(bars[1].twoForOne, true);
      });

      test('throws BarRepositoryException when API client throws', () {
        when(
          () => mockApiClient.fetchBars(),
        ).thenThrow(const BarsApiException('Network error'));

        expect(
          () => repository.getAllBars(),
          throwsA(isA<BarRepositoryException>()),
        );
      });

      test('correctly maps DTO fields to domain entity', () async {
        when(
          () => mockApiClient.fetchBars(),
        ).thenAnswer((_) async => testBarsResponse);

        final bars = await repository.getAllBars();
        final bar = bars[0];

        expect(bar.id, 1);
        expect(bar.name, 'Test Bar 1');
        expect(bar.email, 'bar1@test.com');
        expect(bar.street, 'Street 1');
        expect(bar.latitude, 64.1);
        expect(bar.longitude, -21.9);
        expect(bar.cheapestBeerPrice, 800);
        expect(bar.cheapestWinePrice, 1000);
        expect(bar.twoForOne, false);
        expect(bar.notes, 'Note 1');
      });
    });
  });
}
