import 'package:ccl_app/app/register/bloc/register_cubit.dart';
import 'package:ccl_app/domain/model/user.dart';
import 'package:ccl_app/domain/usecases/user/new_user_usecase.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:ccl_app/domain/core/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../core/utils.dart';

class NewUserUseCaseMock extends Mock implements NewUserUseCase {}

void main() async {
  late NewUserUseCase useCaseMock;
  late RegisterCubit cubit;
  await initEasyLocalization();

  setUpAll(() {
    registerFallbackValue(
      User(
        firstName: 'firstName',
        lastName: 'lastName',
        email: 'email',
        password: 'password',
      ),
    );
  });

  setUp(() {
    useCaseMock = NewUserUseCaseMock();
    cubit = RegisterCubit(useCaseMock);
  });

  test('initial state is $RegisterInit', () {
    expect(cubit.state, RegisterInit());
  });

  group(
      "All the correct states are emitted when 'register()' method is called \n",
      () {
    blocTest<RegisterCubit, RegisterState>(
      'Given $RegisterCubit, '
      "When the 'register()' method is called "
      'And response is an error, '
      'Then the state $RegisterValidatedFields is emitted',
      build: () => cubit,
      act: (RegisterCubit cubit) {
        when(() => useCaseMock.call(any())).thenAnswer(
          (_) async => left(
            const ServerFailure(message: 'error'),
          ),
        );
        return cubit.register();
      },
      expect: () => [isA<RegisterValidatedFields>()],
    );

    blocTest<RegisterCubit, RegisterState>(
      'Given $RegisterCubit, '
      "When the 'register()' method is called "
      'And response is successful , '
      'Then the state $RegisterSucceeded is emitted',
      build: () => cubit,
      act: (RegisterCubit cubit) {
        when(() => useCaseMock.call(any())).thenAnswer((_) async => right(User(
              firstName: "firstName",
              lastName: "lastName",
              email: "email@tets.com",
              password: "pass",
            )));
        cubit.setFirstName("firstName");
        cubit.setLastName("lastName");
        cubit.setEmail("email@tets.com");
        cubit.setPassword("password");
        return cubit.register();
      },
      expect: () => [isA<RegisterSucceeded>()],
      verify: (_) {
        verify(() => useCaseMock(any())).called(1);
      },
    );

    test('Invalid email should issue RegisterValidatedFields', () {
      cubit.setEmail("correo");
      cubit.register();
      expect(cubit.state, isA<RegisterValidatedFields>());
    });
  });
}
