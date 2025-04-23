import 'package:get/get.dart';
import 'package:project/service/supabase_service.dart';
import 'package:project/utils/toast.dart';

class AuthController extends GetxController {
  var isAuthenticatedRx = false.obs;
  bool get isAuthenticated => isAuthenticatedRx.value;
  set isAuthenticated(bool value) => isAuthenticatedRx.value = value;

  var isLoadingRx = false.obs;
  bool get isLoading => isLoadingRx.value;
  set isLoading(bool value) => isLoadingRx.value = value;

  var isRegisteredRx = true.obs;
  bool get isRegistered => isRegisteredRx.value;
  set isRegistered(bool value) => isRegisteredRx.value = value;

  var roleRx = 0.obs;
  int get role => roleRx.value;
  set role(int value) => roleRx.value = value;

  @override
  void onInit() {
    super.onInit();
    SupabaseService.user.subscribeToAuthState((data) async {
      isAuthenticated = SupabaseService.user.session != null;
      if (isAuthenticated) {
        final roleResponse = await SupabaseService.user.getRole();
        role = roleResponse?["role"] ?? 0;
      }
    });
  }

  Future<void> signUp(
    String email,
    String password, [
    String? address,
    DateTime? date,
    String? department,
    String? program,
  ]) async {
    try {
      // TODO: Add the additional parameters to the sign-up method
      isLoading = true;
      await SupabaseService.user.signUp(email, password);
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
