import 'package:project/service/course_activity_service.dart';
import 'package:project/service/course_service.dart';
import 'package:project/service/department_service.dart';
import 'package:project/service/invoice_service.dart';
import 'package:project/service/user_service.dart';

class SupabaseService {
  static UserService userService = UserService();
  static UserService get user => userService;

  static DepartmentService departmentService = DepartmentService();
  static DepartmentService get department => departmentService;

  static CourseService courseService = CourseService();
  static CourseService get course => courseService;

  static CourseActivityService courseActivityService = CourseActivityService();
  static CourseActivityService get courseActivity => courseActivityService;

  static InvoiceService invoiceService = InvoiceService();
  static InvoiceService get invoice => invoiceService;
}
