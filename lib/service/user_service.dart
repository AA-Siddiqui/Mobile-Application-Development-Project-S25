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

  Future<void> signUp(String email, String password) async {
    await _supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
