import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  SupabaseClient get _supabase => Supabase.instance.client;
  Session? get session => _supabase.auth.currentSession;
  User? get user => _supabase.auth.currentUser;

  Future<Map<String, dynamic>> getProfilePageData() async {
    return await Supabase.instance.client
        .from("User")
        .select(
            "name, dob, address, Department(name), Student(rollNo, Program(name, level))")
        .eq("id", user?.id ?? "")
        .single();
  }

  void resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(
      email,
    );
  }

  void subscribeToAuthState(void Function(AuthState) callback) {
    _supabase.auth.onAuthStateChange.listen(callback);
  }

  Future<Map<String, dynamic>?> getRole() async {
    return await _supabase
        .from("User")
        .select("role")
        .eq("id", user?.id ?? "")
        .maybeSingle();
  }

  Future<Map<String, dynamic>?> getStudentDetails() async {
    return await _supabase
        .from("Student")
        .select("id")
        .eq("userId", user?.id ?? "")
        .maybeSingle();
  }

  Future<List<Map<String, dynamic>>> getClassDetails(int roleId) async {
    // TODO: check if this is correct
    return await _supabase
        .from("Enrollment")
        .select(
            "Class(id, Course(name), Teacher(User(name)), Schedule(Attendance(present)), term, section)")
        .eq("studentId", roleId);
  }

  Future<void> signUp(
    String email,
    String password,
    String address,
    DateTime date,
    String department,
    String program,
    String name,
  ) async {
    final signUpResponse =
        await _supabase.auth.signUp(email: email, password: password);
    if (signUpResponse.user != null) {
      final departmentId = await _supabase
          .from("Department")
          .select("id")
          .eq("name", department)
          .single();
      final programId = await _supabase
          .from("Program")
          .select("id")
          .eq("name", program)
          .single();
      final userId = signUpResponse.user!.id;
      await _supabase.from("User").insert({
        "id": userId,
        "name": name,
        "address": address,
        "dob": date.toIso8601String(),
        "departmentId": departmentId["id"],
        "role": 1,
      });
      await _supabase.from("Student").insert({
        "userId": userId,
        "rollNo": "SU92-BSSEM-F22-001",
        "programId": programId["id"],
      });
    }
  }

  Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut(scope: SignOutScope.global);
  }
}
