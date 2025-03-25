import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  var isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    _supabase.auth.onAuthStateChange.listen((data) {
      isAuthenticated.value = _supabase.auth.currentSession != null;
    });
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _supabase.auth.signUp(email: email, password: password);
      Get.snackbar("Success", "Account created! Please verify your email.");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
