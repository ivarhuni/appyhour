import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happyhour_app/application/bars/bar_list/bar_list_cubit.dart';
import 'package:happyhour_app/application/bars/bar_list/bar_list_state.dart';
import 'package:happyhour_app/domain/bars/entities/bar.dart';
import 'package:happyhour_app/domain/bars/enums/sort_preference.dart';
import 'package:happyhour_app/domain/bars/models/happy_hour_days.dart';
import 'package:happyhour_app/domain/bars/models/happy_hour_time.dart';
import 'package:happyhour_app/infrastructure/bars/repository/i_bar_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockBarRepository extends Mock implements IBarRepository {}

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

  group('BarListCubit', () {
    blocTest<BarListCubit, BarListState>(
      'emits [BarListLoading, BarListLoaded] when loadBars succeeds',
      setUp: () {
        when(
          () => mockRepository.getAllBars(),
        ).thenAnswer((_) async => testBars);
      },
      build: () => BarListCubit(repository: mockRepository),
      act: (cubit) => cubit.loadBars(),
      expect: () => [
        const BarListLoading(),
        isA<BarListLoaded>()
            .having((s) => s.bars.length, 'bars length', 3)
            .having((s) => s.filteredBars.length, 'filteredBars length', 3),
      ],
    );

    blocTest<BarListCubit, BarListState>(
      'emits [BarListLoading, BarListError] when loadBars fails',
      setUp: () {
        when(
          () => mockRepository.getAllBars(),
        ).thenThrow(const BarRepositoryException('Network error'));
      },
      build: () => BarListCubit(repository: mockRepository),
      act: (cubit) => cubit.loadBars(),
      expect: () => [
        const BarListLoading(),
        const BarListError('Network error'),
      ],
    );

    blocTest<BarListCubit, BarListState>(
      'setSort sorts by beer price ascending',
      setUp: () {
        when(
          () => mockRepository.getAllBars(),
        ).thenAnswer((_) async => testBars);
      },
      build: () => BarListCubit(repository: mockRepository),
      act: (cubit) async {
        await cubit.loadBars();
        cubit.setSort(SortPreference.beerPrice);
      },
      expect: () => [
        const BarListLoading(),
        isA<BarListLoaded>(),
        isA<BarListLoaded>()
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

    blocTest<BarListCubit, BarListState>(
      'refresh updates bars while in loaded state',
      setUp: () {
        when(
          () => mockRepository.getAllBars(),
        ).thenAnswer((_) async => testBars);
      },
      build: () => BarListCubit(repository: mockRepository),
      seed: () => BarListLoaded(
        bars: testBars,
        filteredBars: testBars,
        sortPreference: SortPreference.beerPrice,
      ),
      act: (cubit) => cubit.refresh(),
      expect: () => [
        isA<BarListLoaded>()
            .having(
              (s) => s.sortPreference,
              'sortPreference',
              SortPreference.beerPrice,
            )
            .having((s) => s.bars.length, 'bars length', 3),
      ],
    );

    blocTest<BarListCubit, BarListState>(
      'updateBarsWithDistance updates bars and reapplies filter/sort',
      setUp: () {
        when(
          () => mockRepository.getAllBars(),
        ).thenAnswer((_) async => testBars);
      },
      build: () => BarListCubit(repository: mockRepository),
      act: (cubit) async {
        await cubit.loadBars();
        final barsWithDistance = testBars.map((bar) {
          return bar.copyWith(distanceFromUser: bar.id * 100.0);
        }).toList();
        cubit.updateBarsWithDistance(barsWithDistance);
      },
      expect: () => [
        const BarListLoading(),
        isA<BarListLoaded>(),
        isA<BarListLoaded>().having(
          (s) => s.bars.every((b) => b.distanceFromUser != null),
          'all bars have distance',
          true,
        ),
      ],
    );

    blocTest<BarListCubit, BarListState>(
      'clearErrorBanner clears the error banner',
      setUp: () {
        when(
          () => mockRepository.getAllBars(),
        ).thenAnswer((_) async => testBars);
      },
      build: () => BarListCubit(repository: mockRepository),
      seed: () => BarListLoaded(
        bars: testBars,
        filteredBars: testBars,
        errorBanner: 'Some error',
      ),
      act: (cubit) => cubit.clearErrorBanner(),
      expect: () => [
        isA<BarListLoaded>().having(
          (s) => s.errorBanner,
          'errorBanner',
          null,
        ),
      ],
    );
  });
}
