import 'package:get/get.dart';
import 'package:project/service/supabase_service.dart';

class StudentInvoiceController extends GetxController {
  /// TODO: Implement caching mechanism for invoices
  /// This will be done by making a student_invoices_actions.dart and student_invoices_model.dart
  /// file and registering the action in the DBHelper class.

  var isLoadingRx = false.obs;
  bool get isLoading => isLoadingRx.value;
  set isLoading(bool value) => isLoadingRx.value = value;

  var invoicesRx = <Map<String, dynamic>>[].obs;
  // ignore: invalid_use_of_protected_member
  List<Map<String, dynamic>> get invoices => invoicesRx.value;
  set invoices(List<Map<String, dynamic>> value) => invoicesRx.value = value;

  void getInvoices(int studentId) async {
    isLoading = true;
    invoices = await SupabaseService.invoice.getInvoices(studentId);
    isLoading = false;
  }
}
