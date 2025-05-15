import 'package:ccl_app/app/register/bloc/register_cubit.dart';
import 'package:ccl_app/app/register/presentation/register_screen.dart';
import 'package:ccl_app/core/di/injection.dart';
import 'package:ccl_app/core/translations/localization_constants.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mocktail/mocktail.dart';

import '../../../core/utils.dart';

class MockedRegisterCubit extends MockCubit<RegisterState>
    implements RegisterCubit {}

class FakedRegisterState extends Fake implements RegisterState {}

void main() async {
  late RegisterCubit cubit;
  late Widget testableWidget;
  await initEasyLocalization();

  setUpAll(() {
    registerFallbackValue(FakedRegisterState());
  });

  void initMainWidget() {
    cubit = MockedRegisterCubit();

    when(() => cubit.start()).thenAnswer((_) => Future.value());

    GetItHelper(GetIt.instance).factory<RegisterCubit>(() => cubit);

    testableWidget = makeTestableWidget(
      child: BlocProvider(
        create: (_) => getIt<RegisterCubit>(),
        child: const RegisterScreen(),
      ),
    );
  }

  group(
      'Testing Loading Text is being shown with '
      'correct copies and with the emission of the correct states', () {
    setUp(() => initMainWidget());
    tearDown(() => GetIt.instance.reset());

    void evaluateMainWidgetsPresence(WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(
            TextFormField, LocaleKeys.register.labelTextFirstName.tr()),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(
            TextFormField, LocaleKeys.register.labelTextLastName.tr()),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(
            TextFormField, LocaleKeys.register.labelTextEmail.tr()),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(
            TextFormField, LocaleKeys.register.labelTextPassword.tr()),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(
            ElevatedButton, LocaleKeys.register.registerButton.tr()),
        findsOneWidget,
      );
    }

    testWidgets(
        'When $RegisterInit state is emitted, '
        "Then only the Loading Text 'is' shown", (WidgetTester tester) async {
      when(() => cubit.state).thenReturn(RegisterInit());
      evaluateMainWidgetsPresence(tester);
    });
  });

  group("Message for Snack Bar behavior", () {
    setUp(() => initMainWidget());
    tearDown(() => GetIt.instance.reset());

    testWidgets(
        'When $RegisterFailed state is emitted, '
        'Then a snack bar is shown with a error message',
        (WidgetTester tester) async {
      when(() => cubit.state).thenReturn(RegisterFailed());
      await tester.pumpWidget(testableWidget);

      whenListen(
        cubit,
        Stream.value(RegisterFailed()),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(LocaleKeys.register.failedMessage.tr()),
        findsOneWidget,
      );
    });
  });
}
