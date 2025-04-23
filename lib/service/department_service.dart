import 'package:supabase_flutter/supabase_flutter.dart';

class DepartmentService {
  static final DepartmentService _instance = DepartmentService._internal();
  factory DepartmentService() => _instance;
  DepartmentService._internal();

  SupabaseClient get _supabase => Supabase.instance.client;
  Session? get session => _supabase.auth.currentSession;
  User? get user => _supabase.auth.currentUser;

  Future<List<Map<String, dynamic>>> getDepartments() async {
    final departments = await _supabase
        .from("Department")
        .select("id, name")
        .order("name", ascending: true);
    return departments;
  }

  Future<List<Map<String, dynamic>>> getPrograms(int departmentId) async {
    final programs = await _supabase
        .from("Program")
        .select("id, name")
        .eq("departmentId", departmentId)
        .order("name", ascending: true);
    return programs;
  }
}
