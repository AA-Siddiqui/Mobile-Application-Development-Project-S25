import 'package:supabase_flutter/supabase_flutter.dart';

class InvoiceService {
  static final InvoiceService _instance = InvoiceService._internal();
  factory InvoiceService() => _instance;
  InvoiceService._internal();

  Future<List<Map<String, dynamic>>> getInvoices(int studentId) async {
    return await Supabase.instance.client
        .from("Invoice")
        .select("description, amount, dueDate, paidDate, term")
        .eq("studentId", studentId)
        .gt("amount", 0);
  }
}
