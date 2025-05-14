import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/global_state/global_state.dart';
import 'package:ccl_app/domain/model/user.dart';
import 'package:ccl_app/domain/repositories/user_repository.dart';
import 'package:ccl_app/domain/usecases/user/new_user_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class UserRepositoryMock extends Mock implements UserRepository {}

class FakeGlobalState extends Fake implements GlobalState {
  @override
  User? user;

  @override
  final List<User> users = [];
}

void main() {
  late UserRepositoryMock repository;
  late FakeGlobalState globalState;
  late NewUserUseCaseImpl useCase;

  final user = User(
    id: 1,
    firstName: "firstName",
    lastName: "lastName",
    email: "email@example.com",
    password: "password",
  );

  final newUser = User(
    id: 2,
    firstName: "firstName",
    lastName: "lastName",
    email: "email2@example.com",
    password: "password",
  );

  setUpAll(() {
    registerFallbackValue(user);
  });

  setUp(() {
    repository = UserRepositoryMock();
    globalState = FakeGlobalState();
    useCase = NewUserUseCaseImpl(globalState, repository);
  });

  test(
    'When repository returns a successful response, '
    'Then globalState.user is updated and result is Right(User)',
    () async {
      when(() => repository.getUsers()).thenAnswer((_) async => right([user]));
      when(() => repository.newUser(any()))
          .thenAnswer((_) async => right(newUser));

      final result = await useCase(newUser);

      verify(() => repository.getUsers()).called(1);
      verify(() => repository.newUser(newUser)).called(1);
      expect(globalState.user, equals(newUser));
      expect(result, right(newUser));
    },
  );

  test(
    'When repository returns a failure, '
    'Then globalState.user remains null and result is Left(Failure)',
    () async {
      const failure = ServerFailure(message: 'Registration failed');
      when(() => repository.getUsers()).thenAnswer((_) async => right([user]));
      when(() => repository.newUser(any()))
          .thenAnswer((_) async => left(failure));

      final result = await useCase(newUser);

      verify(() => repository.getUsers()).called(1);
      verify(() => repository.newUser(newUser)).called(1);
      expect(globalState.user, isNull);
      expect(result, left(failure));
    },
  );

  test(
    'When user with same email already exists in globalState.users, '
    'Then use case should not call repository and return a Failure',
    () async {
      when(() => repository.getUsers()).thenAnswer((_) async => right([user]));
      globalState.users.add(newUser);

      final duplicateUser = User(
        id: 3,
        firstName: "New",
        lastName: "User",
        email: "email2@example.com",
        password: "newpass",
      );

      final result = await useCase(duplicateUser);

      verifyNever(() => repository.newUser(any()));
      expect(globalState.user, isNull);
      expect(result, isA<Left>());
    },
  );

  test(
    'When user has empty firstName or email, '
    'Then should return validation failure without calling repository',
    () async {
      final invalidUser = User(
        id: 4,
        firstName: "",
        lastName: "Doe",
        email: "",
        password: "1234",
      );

      final result = await useCase(invalidUser);

      verifyNever(() => repository.newUser(any()));
      expect(globalState.user, isNull);
      expect(result.isLeft(), true);
    },
  );
}
