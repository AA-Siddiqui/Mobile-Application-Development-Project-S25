import 'package:get/get.dart';
import 'package:project/service/supabase_service.dart';
import 'package:project/utils/toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  var isAuthenticatedRx = false.obs;
  bool get isAuthenticated => isAuthenticatedRx.value;
  set isAuthenticated(bool value) => isAuthenticatedRx.value = value;

  var isLoadingRx = false.obs;
  bool get isLoading => isLoadingRx.value;
  set isLoading(bool value) => isLoadingRx.value = value;

  var isRegisteringRx = true.obs;
  bool get isRegistering => isRegisteringRx.value;
  set isRegistering(bool value) => isRegisteringRx.value = value;

  var roleRx = 0.obs;
  int get role => roleRx.value;
  set role(int value) => roleRx.value = value;

  var roleIdRx = (-1).obs;
  int get roleId => roleIdRx.value;
  set roleId(int value) => roleIdRx.value = value;

  @override
  void onInit() {
    super.onInit();
    SupabaseService.user.subscribeToAuthState((data) async {
      isAuthenticated = SupabaseService.user.session != null;
      if (isAuthenticated) {
        final roleResponse = await SupabaseService.user.getRole();
        role = roleResponse?["role"] ?? 0;
        _getRoleBasedDetails(role);
      }
    });
  }

  Future<void> _getRoleBasedDetails(int role) async {
    switch (role) {
      case 1:
        // Student
        final studentResponse = await SupabaseService.user.getStudentDetails();
        if (studentResponse != null) {
          roleId = studentResponse["id"];
        }
        break;
    }
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
    try {
      isLoading = true;
      await SupabaseService.user
          .signUp(email, password, address, date, department, program, name);
      Toast.info("Success", "Account created! Please verify your email.");
    } catch (e) {
      Toast.error("Error", e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading = true;
      await SupabaseService.user.signIn(email, password);
    } on AuthException catch (e) {
      if (e.message == "Invalid login credentials") {
        Toast.error("Error", "Invalid email or password.");
      } else if (e.message == "Email not confirmed") {
        Toast.error("Error", "Please verify your email.");
      } else {
        Toast.error("Error", e.message);
      }
    } catch (e) {
      Toast.error("Error", e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> signOut() async {
    await SupabaseService.user.signOut();
  }
}
