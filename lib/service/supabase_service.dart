import 'package:project/service/department_service.dart';
import 'package:project/service/user_service.dart';

class SupabaseService {
  static UserService userService = UserService();
  static UserService get user => userService;

  static DepartmentService departmentService = DepartmentService();
  static DepartmentService get department => departmentService;
}
