import 'package:flutter_test/flutter_test.dart';
import 'package:ccl_app/domain/model/user.dart';
import 'package:ccl_app/domain/global_state/global_state.dart';

void main() {
  group('GlobalState', () {
    final state = GlobalState();

    test('The initial state is null user and empty user list', () {
      expect(state.user, isNull);
      expect(state.users, isEmpty);
    });

    test('can assign a user and add to users list', () {
      final user = User(
        id: 1,
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        password: '1234',
      );

      state.user = user;
      state.users.add(user);

      expect(state.user, user);
      expect(state.users, contains(user));
    });
  });
}
