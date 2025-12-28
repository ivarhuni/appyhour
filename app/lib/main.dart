import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:happyhour_app/domain/repositories/bar_repository.dart';
import 'package:happyhour_app/infrastructure/repositories/bar_repository_impl.dart';
import 'package:happyhour_app/presentation/cubits/bar_detail/bar_detail_cubit.dart';
import 'package:happyhour_app/presentation/cubits/bars_list/bars_list_cubit.dart';
import 'package:happyhour_app/presentation/screens/bar_detail_screen.dart';
import 'package:happyhour_app/presentation/screens/bars_list_screen.dart';

void main() {
  runApp(const HappyHourApp());
}

class HappyHourApp extends StatelessWidget {
  const HappyHourApp({super.key});

  @override
  Widget build(BuildContext context) {
    final barRepository = BarRepositoryImpl();

    return RepositoryProvider<BarRepository>.value(
      value: barRepository,
      child: MaterialApp.router(
        title: 'Happy Hour',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(Brightness.light),
        darkTheme: _buildTheme(Brightness.dark),
        routerConfig: _router(barRepository),
      ),
    );
  }

  GoRouter _router(BarRepository repository) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider(
            create: (_) => BarsListCubit(repository: repository),
            child: const BarsListScreen(),
          ),
        ),
        GoRoute(
          path: '/bar/:id',
          builder: (context, state) {
            final barId = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
            return BlocProvider(
              create: (_) =>
                  BarDetailCubit(repository: repository, barId: barId),
              child: const BarDetailScreen(),
            );
          },
        ),
      ],
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    // Warm amber/gold color scheme for happy hour vibes
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFE6A919), // Warm amber
      brightness: brightness,
      primary: const Color(0xFFE6A919),
      secondary: const Color(0xFF8B4513), // Saddle brown
      tertiary: const Color(0xFF2E8B57), // Sea green for 2-for-1
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? colorScheme.surface : Colors.white,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: isDark ? colorScheme.surfaceContainerHigh : Colors.white,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
