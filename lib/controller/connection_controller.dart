import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionStatusController extends GetxController {
  final InternetConnectionChecker connectionChecker;
  var isConnected = true.obs;

  ConnectionStatusController({required this.connectionChecker}) {
    _initConnectionListener();
  }

  void _initConnectionListener() {
    connectionChecker.onStatusChange.listen((status) {
      isConnected.value = status == InternetConnectionStatus.connected;
      if (!isConnected.value) {
        Get.snackbar(
          "No Internet Connection",
          "Please check your internet connection",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else{
        print("Sab solid hai bhai, apun hai na");
      }
    });
  }
}

