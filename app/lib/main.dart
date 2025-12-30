import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:happyhour_app/application/bars/bar_detail/bar_detail_cubit.dart';
import 'package:happyhour_app/application/bars/bar_list/bar_list_cubit.dart';
import 'package:happyhour_app/gen_l10n/app_localizations.dart';
import 'package:happyhour_app/infrastructure/bars/repository/bar_repository.dart';
import 'package:happyhour_app/infrastructure/bars/repository/i_bar_repository.dart';
import 'package:happyhour_app/presentation/bars/bar_detail/bar_detail.dart';
import 'package:happyhour_app/presentation/bars/bar_list/bar_list.dart';
import 'package:happyhour_app/presentation/core/navigation/app_page_transitions.dart';
import 'package:happyhour_app/presentation/core/theme/theme.dart';

void main() {
  runApp(const HappyHourApp());
}

class HappyHourApp extends StatelessWidget {
  const HappyHourApp({super.key});

  @override
  Widget build(BuildContext context) {
    final barRepository = BarRepository();

    return RepositoryProvider<IBarRepository>.value(
      value: barRepository,
      child: MaterialApp.router(
        title: 'Happy Hour',
        debugShowCheckedModeBanner: false,
        // Force dark mode only - no light theme
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: _router(barRepository),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('is'),
          Locale('pl'),
        ],
      ),
    );
  }

  GoRouter _router(IBarRepository repository) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider(
            create: (_) => BarListCubit(repository: repository),
            child: const BarList(),
          ),
        ),
        GoRoute(
          path: '/bar/:id',
          pageBuilder: (context, state) {
            final barId = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
            return AppPageTransitions.fadeSlide(
              context,
              state,
              BlocProvider(
                create: (_) =>
                    BarDetailCubit(repository: repository, barId: barId),
                child: const BarDetail(),
              ),
            );
          },
        ),
      ],
    );
  }
}
