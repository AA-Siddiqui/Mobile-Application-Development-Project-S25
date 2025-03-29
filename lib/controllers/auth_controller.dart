import 'package:get/get.dart';
import 'package:project/utils/toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  var isAuthenticatedRx = false.obs;
  bool get isAuthenticated => isAuthenticatedRx.value;
  set isAuthenticated(bool value) => isAuthenticatedRx.value = value;

  var roleRx = 0.obs;
  int get role => roleRx.value;
  set role(int value) => roleRx.value = value;

  @override
  void onInit() {
    super.onInit();
    _supabase.auth.onAuthStateChange.listen((data) async {
      isAuthenticated = _supabase.auth.currentSession != null;
      _supabase
          .from("User")
          .select("role")
          .eq("id", _supabase.auth.currentUser?.id ?? "")
          .maybeSingle()
          .then((value) {
        if (value == null) {
          Toast.error("Role Error", "Role not found!");
          role = 0;
          return;
        }
        role = value["role"];
        Toast.info("Role", role.toString());
      }).catchError((error) {
        error("Error", "Role Error");
      });
    });
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _supabase.auth.signUp(email: email, password: password);
      Toast.info("Success", "Account created! Please verify your email.");
    } catch (e) {
      Toast.error("Error", e.toString());
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      Toast.error("Error", e.toString());
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
