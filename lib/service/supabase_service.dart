import 'package:project/service/user_service.dart';

class SupabaseService {
  static UserService userService = UserService();
  static UserService get user => userService;
}
