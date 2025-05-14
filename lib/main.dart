import 'package:auto_route/auto_route.dart';
import 'package:ccl_app/core/di/injection.dart';
import 'package:ccl_app/core/routes/routes.dart';
import 'package:ccl_app/core/themes/ccl_app_theme.dart';
import 'package:ccl_app/core/translations/localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await EasyLocalization.ensureInitialized();
  configureInjection();
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
  final _appRouter = getIt<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(
        navigatorObservers: () => [AutoRouteObserver()],
      ),
      theme: CclAppThemeData.lightTheme,
      darkTheme: CclAppThemeData.darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
