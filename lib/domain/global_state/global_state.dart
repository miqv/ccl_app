import 'package:injectable/injectable.dart';
import 'package:ccl_app/domain/model/user.dart';

@injectable
class GlobalState {
  User? user;
  final List<User> users = [];
}
