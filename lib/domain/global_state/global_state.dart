import 'package:injectable/injectable.dart';
import 'package:ccl_app/domain/model/product.dart';
import 'package:ccl_app/domain/model/user.dart';

/// A singleton class that holds global in-memory state for the application.
///
/// This class is designed to temporarily store data such as the current logged-in user,
/// the list of users, and the list of products throughout the app's lifecycle.
///
/// It is registered as a dependency using `injectable` for convenient injection across the app.
///
/// **Note**: This class is suitable for ephemeral or session-based data. Avoid using it
/// for persistent storage or critical data handling in production.
///
/// ### Properties:
/// - [user]: The currently logged-in [User].
/// - [users]: A mutable list of all [User] objects available in memory.
/// - [products]: A mutable list of all [Product] objects available in memory.
///
/// ### Example Usage:
/// ```dart
/// final globalState = getIt<GlobalState>();
/// globalState.user = loggedInUser;
/// globalState.products.add(newProduct);
/// ```
@injectable
class GlobalState {
  /// Internal singleton instance of [GlobalState].
  static final GlobalState _globalState = GlobalState._internal();

  /// Factory constructor returning the singleton instance.
  factory GlobalState() {
    return _globalState;
  }

  /// Private named constructor for singleton initialization.
  GlobalState._internal();

  /// Currently logged-in user (if any).
  User? user;

  /// List of all users (non-persistent).
  final List<User> users = [];

  /// List of all products (non-persistent).
  final List<Product> products = [];
}
