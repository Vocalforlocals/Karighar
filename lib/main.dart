import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/router.dart';
import 'core/theme/app_theme.dart';
import 'features/artisan/bloc/artisan_bloc.dart';
import 'features/buyer/bloc/buyer_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KarigharApp());
}

class KarigharApp extends StatelessWidget {
  const KarigharApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ArtisanBloc>(
          create: (context) => ArtisanBloc()..add(LoadArtisanDataEvent()),
        ),
        BlocProvider<BuyerBloc>(
          create: (context) => BuyerBloc()..add(LoadBuyerMarketplaceEvent()),
        ),
      ],
      child: ValueListenableBuilder<AppLanguage>(
        valueListenable: LocaleManager.currentLanguage,
        builder: (context, currentLang, _) {
          return MaterialApp.router(
            key: ValueKey(currentLang),
            locale: LocaleManager.getLocale(currentLang),
            title: 'Karighar',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}

/// Backward compatibility alias
typedef ShilpSetuApp = KarigharApp;
