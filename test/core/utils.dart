import 'package:auto_route/auto_route.dart';
import 'package:ccl_app/core/themes/ccl_app_theme.dart';
import 'package:ccl_app/core/translations/localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData buildThemeData() {
  return CclAppThemeData.lightTheme;
}

Future<void> initEasyLocalization() async {
  EasyLocalization.logger.enableLevels = <LevelMessages>[
    LevelMessages.error,
    LevelMessages.warning,
  ];
  SharedPreferences.setMockInitialValues({});

  await EasyLocalization.ensureInitialized();
}

Widget makeTestableWidget({
  ThemeData? theme,
  required Widget child,
}) {
  theme ??= buildThemeData();
  return EasyLocalization(
    path: 'lib/app/core/translations',
    assetLoader: const Localization(),
    supportedLocales: const [Locale('es', 'CO')],
    child: Builder(
      builder: (context) {
        return MaterialApp(
          theme: theme,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          home: child,
        );
      },
    ),
  );
}

Widget makeTestableRouterWidget({
  ThemeData? theme,
  required RootStackRouter router,
}) {
  theme ??= buildThemeData();
  return EasyLocalization(
    path: 'lib/app/core/translations',
    assetLoader: const Localization(),
    supportedLocales: const [Locale('es', 'CO')],
    child: Builder(
      builder: (context) {
        return MaterialApp.router(
          theme: theme,
          routerConfig: router.config(),
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
        );
      },
    ),
  );
}
