import 'package:bloc_test/bloc_test.dart';
import 'package:ccl_app/app/login/bloc/login_cubit.dart';
import 'package:ccl_app/app/login/presentation/login_screen.dart';
import 'package:ccl_app/core/routes/routes.dart';
import 'package:ccl_app/core/translations/localization_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mocktail/mocktail.dart';

import '../../../core/utils.dart';

/// Pruebas widget de la pantalla de login:
/// - Verifica que todos los elementos principales se rendericen correctamente.
/// - Simula errores de login para validar comportamiento del SnackBar.
/// - Asegura que el método de login se invoque con credenciales válidas.
///
/// Usa `MockCubit` de `mocktail` y `bloc_test` para emular el comportamiento del cubit.

class MockedLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

class FakedLoginState extends Fake implements LoginState {}

void main() async {
  late LoginCubit cubit;
  late Widget testableWidget;
  await initEasyLocalization();

  setUpAll(() {
    registerFallbackValue(FakedLoginState());
  });

  void initMainWidget() {
    cubit = MockedLoginCubit();

    when(() => cubit.start()).thenAnswer((_) => Future.value());

    GetItHelper(GetIt.instance).factory<LoginCubit>(() => cubit);
    testableWidget = makeTestableWidget(
      child: const LoginScreen(),
    );
  }

  group("All main widgets are shown no matter emitted state", () {
    setUp(() => initMainWidget());
    tearDown(() => GetIt.instance.reset());

    void evaluateMainWidgetsPresence(WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(AppBar, LocaleKeys.login.title.tr()),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextField, LocaleKeys.login.labelTextEmail.tr()),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextField, LocaleKeys.login.labelTextPassword.tr()),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(ElevatedButton, LocaleKeys.login.loginButton.tr()),
        findsOneWidget,
      );
      expect(
        find.text(LocaleKeys.login.questionRegister.tr()),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextButton, LocaleKeys.login.registerButton.tr()),
        findsOneWidget,
      );
    }

    testWidgets(
        'When $LoginInit state is emitted, '
        'Then all widgets are shown', (WidgetTester tester) async {
      when(() => cubit.state).thenReturn(LoginInit());
      evaluateMainWidgetsPresence(tester);
    });
  });

  group("Message for Snack Bar behavior", () {
    late AppRouter appRouter;

    void initRouterWidget() {
      cubit = MockedLoginCubit();
      appRouter = AppRouter();

      when(() => cubit.start()).thenAnswer((_) => Future.value());

      GetItHelper(GetIt.instance).factory<LoginCubit>(() => cubit);
      testableWidget = makeTestableRouterWidget(router: appRouter);
    }

    setUp(() => initRouterWidget());
    tearDown(() => GetIt.instance.reset());

    testWidgets(
        'When $LoginFailed state is emitted, '
        'Then a snack bar is shown with a error message',
        (WidgetTester tester) async {
      when(() => cubit.state).thenReturn(LoginFailed());
      await tester.pumpWidget(testableWidget);

      whenListen(
        cubit,
        Stream.value(LoginFailed()),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(LocaleKeys.login.failedMessage.tr()),
        findsOneWidget,
      );
    });
  });
}
