part of 'navigation_cubit.dart';

/// Base abstract class for all navigation-related states.
///
/// Serves as a common type for all states managed by [NavigationCubit].
abstract class NavigationState {
  /// Constant constructor to ensure immutability.
  const NavigationState();
}

/// Abstract helper class that mixes in [EquatableMixin] for value comparison support.
///
/// Used as a base for states that require equality comparison.
abstract class NavigationStateEquatable extends NavigationState
    with EquatableMixin {
  /// Constant constructor to ensure immutability.
  const NavigationStateEquatable();

  @override
  List<Object> get props => <Object>[];
}

/// Initial state emitted by [NavigationCubit] when the screen is first loaded.
class NavigationInit extends NavigationStateEquatable {}

/// State representing a loaded user object.
///
/// Typically used to indicate the current user in the navigation context.
class NavigationUser extends NavigationState {
  /// Creates a [NavigationUser] state with the given [user].
  const NavigationUser({required this.user});

  /// The current authenticated user.
  final User user;
}

/// State indicating that a navigation-related operation has succeeded.
///
/// May include a token or credential that can be used in subsequent operations.
class NavigationSucceeded extends NavigationState {
  /// Creates a [NavigationSucceeded] state with the provided [token].
  const NavigationSucceeded({required this.token});

  /// Token or credential obtained after a successful operation.
  final String token;
}

/// State indicating that a navigation-related operation has failed.
///
/// Can be used to show error messages to the user.
class NavigationFailed extends NavigationState {
  /// Creates a [NavigationFailed] state with the provided [errorMessage].
  const NavigationFailed({required this.errorMessage});

  /// Error message describing the failure.
  final String errorMessage;
}

/// State emitted when a specific tab in the bottom navigation bar is selected.
///
/// [selectedIndex] indicates the index of the selected tab.
class NavigationSelected extends NavigationState {
  /// Creates a [NavigationSelected] state with the given index.
  const NavigationSelected({required this.selectedIndex});

  /// Index of the currently selected tab.
  final int selectedIndex;
}
