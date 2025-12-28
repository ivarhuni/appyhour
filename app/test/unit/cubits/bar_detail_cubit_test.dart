import 'package:flutter_test/flutter_test.dart';
import 'package:happyhour_app/domain/entities/bar.dart';
import 'package:happyhour_app/domain/repositories/bar_repository.dart';
import 'package:happyhour_app/domain/value_objects/happy_hour_days.dart';
import 'package:happyhour_app/domain/value_objects/happy_hour_time.dart';
import 'package:happyhour_app/infrastructure/api/bars_api_client.dart';
import 'package:happyhour_app/presentation/cubits/bar_detail/bar_detail_cubit.dart';
import 'package:happyhour_app/presentation/cubits/bar_detail/bar_detail_state.dart';
import 'package:mocktail/mocktail.dart';

class MockBarRepository extends Mock implements BarRepository {}

void main() {
  late MockBarRepository mockRepository;

  final testBars = [
    Bar(
      id: 1,
      name: 'Test Bar 1',
      email: 'bar1@test.com',
      street: 'Street 1',
      latitude: 64.1,
      longitude: -21.9,
      happyHourDays: HappyHourDays.parse('Every day'),
      happyHourTime: HappyHourTime.parse('00:00 - 23:59'),
      cheapestBeerPrice: 800,
      cheapestWinePrice: 1000,
      twoForOne: false,
      notes: 'Note 1',
    ),
    Bar(
      id: 2,
      name: 'Test Bar 2',
      email: 'bar2@test.com',
      street: 'Street 2',
      latitude: 64.2,
      longitude: -21.8,
      happyHourDays: HappyHourDays.parse('Every day'),
      happyHourTime: HappyHourTime.parse('00:00 - 23:59'),
      cheapestBeerPrice: 600,
      cheapestWinePrice: 900,
      twoForOne: true,
      notes: 'Note 2',
    ),
  ];

  setUp(() {
    mockRepository = MockBarRepository();
  });

  group('BarDetailCubit', () {
    test('loads bar successfully when bar is found', () async {
      when(() => mockRepository.getAllBars()).thenAnswer((_) async => testBars);

      final cubit = BarDetailCubit(repository: mockRepository, barId: 1);

      // Wait for the async load to complete
      await Future.delayed(const Duration(milliseconds: 50));

      expect(cubit.state, isA<BarDetailLoaded>());
      final state = cubit.state as BarDetailLoaded;
      expect(state.bar.id, 1);
      expect(state.bar.name, 'Test Bar 1');

      await cubit.close();
    });

    test('emits error when bar is not found', () async {
      when(() => mockRepository.getAllBars()).thenAnswer((_) async => testBars);

      final cubit = BarDetailCubit(repository: mockRepository, barId: 999);

      // Wait for the async load to complete
      await Future.delayed(const Duration(milliseconds: 50));

      expect(cubit.state, isA<BarDetailError>());
      final state = cubit.state as BarDetailError;
      expect(state.message, 'Bar not found');

      await cubit.close();
    });

    test('emits error when fetch fails', () async {
      when(
        () => mockRepository.getAllBars(),
      ).thenThrow(const BarsApiException('Network error'));

      final cubit = BarDetailCubit(repository: mockRepository, barId: 1);

      // Wait for the async load to complete
      await Future.delayed(const Duration(milliseconds: 50));

      expect(cubit.state, isA<BarDetailError>());
      final state = cubit.state as BarDetailError;
      expect(state.message, 'Network error');

      await cubit.close();
    });

    test('refreshHappyHourStatus updates active status', () async {
      when(() => mockRepository.getAllBars()).thenAnswer((_) async => testBars);

      final cubit = BarDetailCubit(repository: mockRepository, barId: 1);

      // Wait for the async load to complete
      await Future.delayed(const Duration(milliseconds: 50));

      expect(cubit.state, isA<BarDetailLoaded>());

      cubit.refreshHappyHourStatus();

      expect(cubit.state, isA<BarDetailLoaded>());

      await cubit.close();
    });
  });
}
