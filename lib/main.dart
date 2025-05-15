import 'package:auto_route/auto_route.dart';
import 'package:ccl_app/core/di/injection.dart';
import 'package:ccl_app/core/routes/routes.dart';
import 'package:ccl_app/core/themes/ccl_app_theme.dart';
import 'package:ccl_app/core/translations/localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

/// Entry point of the Flutter application.
void main() async {
  // Ensures all bindings are initialized before running the app.
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Preserves the native splash screen until initialization completes.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Ensures localization is fully initialized before app startup.
  await EasyLocalization.ensureInitialized();

  // Configures dependency injection using injectable.
  configureInjection();

  // Launches the application wrapped in localization support.
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('es', 'CO')],
      path: 'lib/app/core/translations',
      assetLoader: const Localization(),
      fallbackLocale: const Locale('es', 'CO'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Dependency-injected router using `auto_route`
  final _appRouter = getIt<AppRouter>();

  final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Configures navigation using auto_route
      routerConfig: _appRouter.config(
        navigatorObservers: () => [AutoRouteObserver(), routeObserver],
      ),

      // Application theme definitions
      theme: CclAppThemeData.lightTheme,
      darkTheme: CclAppThemeData.darkTheme,
      themeMode: ThemeMode.system,

      // Localization configuration
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

    );
  }
}
