import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import '../main.dart';
import '../no_internet_page.dart';
import "../pages/First_page.dart";

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      Get.offAll(() => NoInternetPage());
    } else {
      final isLoggedIn = Supabase.instance.client.auth.currentUser;
      if (isLoggedIn != null) {
        Get.offAll(() => const MainPage());
      } else {
        Get.offAll(() => const FirstPage());
      }
    }
  }
}
