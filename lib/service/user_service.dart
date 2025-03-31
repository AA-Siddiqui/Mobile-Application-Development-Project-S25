import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  static get _supabase => Supabase.instance.client;
  static Session? get session => _supabase.auth.currentSession;
  static User? get user => _supabase.auth.currentUser;

  static Future<Map> getProfilePageData() async {
    return await Supabase.instance.client
        .from("User")
        .select(
            "name, dob, address, Department(name), Student(rollNo, Program(name, level))")
        .eq("id", user?.id ?? "")
        .single();
  }

  static void resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(
      email,
    );
  }

  static void subscribeToAuthState(void Function(AuthState) callback) {
    _supabase.auth.onAuthStateChange.listen(callback);
  }

  static Future<Map?> getRole() async {
    return await _supabase
        .from("User")
        .select("role")
        .eq("id", user?.id ?? "")
        .maybeSingle();
  }

  static Future<void> signUp(String email, String password) async {
    await _supabase.auth.signUp(email: email, password: password);
  }

  static Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  static Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
