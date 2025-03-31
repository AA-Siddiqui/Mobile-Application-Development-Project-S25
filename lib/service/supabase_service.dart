import 'package:project/service/user_service.dart';

class SupabaseService {
  static UserService userService = UserService();
  static get user => userService;
}
