import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happyhour_app/domain/entities/bar.dart';
import 'package:happyhour_app/domain/repositories/bar_repository.dart';
import 'package:happyhour_app/domain/value_objects/happy_hour_days.dart';
import 'package:happyhour_app/domain/value_objects/happy_hour_time.dart';
import 'package:happyhour_app/domain/value_objects/sort_preference.dart';
import 'package:happyhour_app/infrastructure/api/bars_api_client.dart';
import 'package:happyhour_app/presentation/cubits/bars_list/bars_list_cubit.dart';
import 'package:happyhour_app/presentation/cubits/bars_list/bars_list_state.dart';
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
      happyHourTime: HappyHourTime.parse('15:00 - 17:00'),
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
      happyHourTime: HappyHourTime.parse('14:00 - 18:00'),
      cheapestBeerPrice: 600,
      cheapestWinePrice: 900,
      twoForOne: true,
      notes: 'Note 2',
    ),
    Bar(
      id: 3,
      name: 'Test Bar 3',
      email: 'bar3@test.com',
      street: 'Street 3',
      latitude: 64.3,
      longitude: -21.7,
      happyHourDays: HappyHourDays.parse('Mon-Fri'),
      happyHourTime: HappyHourTime.parse('12:00 - 14:00'),
      cheapestBeerPrice: 1000,
      cheapestWinePrice: 1200,
      twoForOne: false,
      notes: 'Note 3',
    ),
  ];

  setUp(() {
    mockRepository = MockBarRepository();
  });

  group('BarsListCubit', () {
    blocTest<BarsListCubit, BarsListState>(
      'emits [BarsListLoading, BarsListLoaded] when loadBars succeeds',
      setUp: () {
        when(
          () => mockRepository.getAllBars(),
        ).thenAnswer((_) async => testBars);
      },
      build: () => BarsListCubit(repository: mockRepository),
      act: (cubit) => cubit.loadBars(),
      expect: () => [
        const BarsListLoading(),
        isA<BarsListLoaded>()
            .having((s) => s.bars.length, 'bars length', 3)
            .having((s) => s.filteredBars.length, 'filteredBars length', 3),
      ],
    );

    blocTest<BarsListCubit, BarsListState>(
      'emits [BarsListLoading, BarsListError] when loadBars fails',
      setUp: () {
        when(
          () => mockRepository.getAllBars(),
        ).thenThrow(const BarsApiException('Network error'));
      },
      build: () => BarsListCubit(repository: mockRepository),
      act: (cubit) => cubit.loadBars(),
      expect: () => [
        const BarsListLoading(),
        const BarsListError('Network error'),
      ],
    );

    blocTest<BarsListCubit, BarsListState>(
      'setSort sorts by beer price ascending',
      setUp: () {
        when(
          () => mockRepository.getAllBars(),
        ).thenAnswer((_) async => testBars);
      },
      build: () => BarsListCubit(repository: mockRepository),
      act: (cubit) async {
        await cubit.loadBars();
        cubit.setSort(SortPreference.beerPrice);
      },
      expect: () => [
        const BarsListLoading(),
        isA<BarsListLoaded>(),
        isA<BarsListLoaded>()
            .having(
              (s) => s.sortPreference,
              'sortPreference',
              SortPreference.beerPrice,
            )
            .having(
              (s) => s.filteredBars.first.cheapestBeerPrice,
              'first bar price',
              600,
            )
            .having(
              (s) => s.filteredBars.last.cheapestBeerPrice,
              'last bar price',
              1000,
            ),
      ],
    );

    blocTest<BarsListCubit, BarsListState>(
      'refresh updates bars while in loaded state',
      setUp: () {
        when(
          () => mockRepository.getAllBars(),
        ).thenAnswer((_) async => testBars);
      },
      build: () => BarsListCubit(repository: mockRepository),
      seed: () => BarsListLoaded(
        bars: testBars,
        filteredBars: testBars,
        sortPreference: SortPreference.beerPrice,
      ),
      act: (cubit) => cubit.refresh(),
      expect: () => [
        isA<BarsListLoaded>()
            .having(
              (s) => s.sortPreference,
              'sortPreference',
              SortPreference.beerPrice,
            )
            .having((s) => s.bars.length, 'bars length', 3),
      ],
    );

    blocTest<BarsListCubit, BarsListState>(
      'updateBarsWithDistance updates bars and reapplies filter/sort',
      setUp: () {
        when(
          () => mockRepository.getAllBars(),
        ).thenAnswer((_) async => testBars);
      },
      build: () => BarsListCubit(repository: mockRepository),
      act: (cubit) async {
        await cubit.loadBars();
        final barsWithDistance = testBars.map((bar) {
          return bar.copyWith(distanceFromUser: bar.id * 100.0);
        }).toList();
        cubit.updateBarsWithDistance(barsWithDistance);
      },
      expect: () => [
        const BarsListLoading(),
        isA<BarsListLoaded>(),
        isA<BarsListLoaded>().having(
          (s) => s.bars.every((b) => b.distanceFromUser != null),
          'all bars have distance',
          true,
        ),
      ],
    );

    blocTest<BarsListCubit, BarsListState>(
      'clearErrorBanner clears the error banner',
      setUp: () {
        when(
          () => mockRepository.getAllBars(),
        ).thenAnswer((_) async => testBars);
      },
      build: () => BarsListCubit(repository: mockRepository),
      seed: () => BarsListLoaded(
        bars: testBars,
        filteredBars: testBars,
        errorBanner: 'Some error',
      ),
      act: (cubit) => cubit.clearErrorBanner(),
      expect: () => [
        isA<BarsListLoaded>().having(
          (s) => s.errorBanner,
          'errorBanner',
          null,
        ),
      ],
    );
  });
}
