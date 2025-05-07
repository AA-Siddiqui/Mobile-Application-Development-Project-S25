import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectionController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      isOnline = !(result.length == 1 && result[0] == ConnectivityResult.none);
    });
  }

  var isOnlineRx = false.obs;
  bool get isOnline => isOnlineRx.value;
  set isOnline(bool value) => isOnlineRx.value = value;
}
