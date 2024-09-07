
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:TrendyFeet/controller/login_controller.dart';
import 'package:TrendyFeet/controller/payment_controller.dart';
import 'package:TrendyFeet/controller/purchase_controller.dart';
import 'package:TrendyFeet/pages/login_page.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'controller/connection_controller.dart';
import 'controller/home_controller.dart';
import 'firebase_options.dart';

void main()async{
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  Get.put(LoginController());
  Get.put(HomeController());
  Get.put(PurchaseController());
  Get.put(PaymentController());

  final connectionChecker = InternetConnectionChecker();
  Get.put(ConnectionStatusController(connectionChecker: connectionChecker));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var connectionStatusController=Get.find<ConnectionStatusController>();
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true
      ),
      home: connectionStatusController.isConnected.value
          ? LoginPage()
          : NoInternetPage(),
    );
  }
}
class NoInternetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConnectionStatusController connectionStatusController = Get.find();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              "No internet connection",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Please check your connection and try again.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                bool result = await connectionStatusController.connectionChecker.hasConnection;
                if (result) {
                  connectionStatusController.isConnected.value = true;
                  Get.offAll(() => LoginPage()); // Go back to the LoginPage
                } else {
                  Get.snackbar(
                    "Still No Connection",
                    "Please check your internet connection",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}