import 'package:ccl_app/domain/model/user.dart';
import 'package:ccl_app/domain/usecases/login/login_usecase.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:ccl_app/app/login/bloc/login_cubit.dart';
import 'package:ccl_app/domain/core/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../core/utils.dart';

class LoginUseCaseMock extends Mock implements LoginUseCase {}

void main() async {
  late LoginUseCaseMock useCaseMock;
  late LoginCubit cubit;
  await initEasyLocalization();

  setUpAll(() {
    registerFallbackValue(
      LoginParams(email: '', password: ''),
    );
  });

  setUp(() {
    useCaseMock = LoginUseCaseMock();
    cubit = LoginCubit(useCaseMock);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is $LoginInit', () async {
    cubit.start();
    expect(cubit.state, LoginInit());
  });

  group("All the correct states are emitted when 'login()' method is called \n",
      () {
    blocTest<LoginCubit, LoginState>(
      'Given $LoginCubit, '
      "When the 'login()' method is called "
      'And response is an error, '
      'Then the state $LoginFailed is emitted',
      build: () => cubit,
      act: (LoginCubit cubit) {
        when(() => useCaseMock.call(any())).thenAnswer(
          (_) async => left(
            const ServerFailure(message: 'error'),
          ),
        );
        return cubit.login("email@tets.com", "pass");
      },
      expect: () => [isA<LoginFailed>()],
      verify: (_) {
        verify(() => useCaseMock(any())).called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'Given $LoginCubit, '
      "When the 'login()' method is called "
      'And response is successful , '
      'Then the state $LoginSucceeded is emitted',
      build: () => cubit,
      act: (LoginCubit cubit) {
        when(() => useCaseMock.call(any())).thenAnswer((_) async => right(User(
              firstName: "firstName",
              lastName: "lastName",
              email: "email@tets.com",
              password: "pass",
            )));
        return cubit.login("email@tets.com", "pass");
      },
      expect: () => [isA<LoginSucceeded>()],
      verify: (_) {
        verify(() => useCaseMock(any())).called(1);
      },
    );

    test('toggle password visibility toggle visibility', () {
      cubit.togglePasswordVisibility();
      expect(cubit.state, isA<LoginPassword>());
      final state = cubit.state as LoginPassword;
      expect(state.isPasswordVisible, true);

      cubit.togglePasswordVisibility();
      final state2 = cubit.state as LoginPassword;
      expect(state2.isPasswordVisible, false);
    });

    test(
        'Login with invalid email does not call the use case'
        'And issues LoginFailed', () async {
      await cubit.login('correo-invalido', '1234');
      expect(cubit.state, isA<LoginFailed>());
      verifyNever(() => useCaseMock.call(any()));
    });

    test('Login with empty fields issues LoginFailed', () async {
      await cubit.login('', '');
      expect(cubit.state, isA<LoginFailed>());
      verifyNever(() => useCaseMock.call(any()));
    });
  });
}
