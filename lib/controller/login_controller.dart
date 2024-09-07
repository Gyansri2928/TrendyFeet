import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'package:TrendyFeet/models/user/user.dart';
import 'package:TrendyFeet/pages/home_page.dart';

class LoginController extends GetxController {
  GetStorage box = GetStorage();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference usercollection;

  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController LoginNumber = TextEditingController();

  OtpFieldControllerV2 otp = OtpFieldControllerV2();
  bool otpFieldShow = false;
  int? otpsend;
  int? otpenter;

  bool isSendingOtp = false;

  var loginUser = Rx<User?>(null); // Use Rx for reactive updates

  @override
  void onReady() {
    Map<String, dynamic>? user = box.read('loginUser');
    if (user != null) {
      loginUser.value = User.fromJson(user);
      Get.to(const HomePage());
    }
    super.onReady();
  }

  @override
  void onInit() {
    usercollection = firestore.collection('users');
    super.onInit();
  }

  Future<User?> getUserByPhoneNumber(String phoneNumber) async {
    try {
      QuerySnapshot querySnapshot = await usercollection
          .where('number', isEqualTo: int.tryParse(phoneNumber))
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userDoc = querySnapshot.docs.first;
        var userData = userDoc.data() as Map<String, dynamic>;
        return User.fromJson(userData);
      } else {
        print("No user found with the phone number $phoneNumber.");
        return null;
      }
    } catch (e) {
      print("Error retrieving user details: $e");
      return null;
    }
  }

  void addUser() {
    try {
      if (otpsend == otpenter) {
        DocumentReference doc = usercollection.doc();
        User user = User(
          id: doc.id,
          name: name.text,
          number: int.parse(number.text),
        );

        final userJson = user.toJson();
        doc.set(userJson);

        loginUser.value = user; // Update observable user

        Get.snackbar('Success', 'User added successfully', colorText: Colors.green);
        Get.to(HomePage());

        name.clear();
        number.clear();
        otp.clear();
      } else {
        Get.snackbar("Error", "OTP is incorrect", colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print('Error adding user: $e');
    }
  }

  void sendOtp() async {
    if (isSendingOtp) return;

    isSendingOtp = true;
    update();

    try {
      if (name.text.isEmpty || number.text.isEmpty) {
        Get.snackbar('Error', 'Please fill in all fields', colorText: Colors.red);
        return;
      }

      final random = Random();
      int otp = 1000 + random.nextInt(9000);
      String mobilenumber = number.text;

      String url =
          'https://www.fast2sms.com/dev/bulkV2?authorization=ClbSem8jT7VhgzasIL9KZAvFYXO5R1Wc6EDxup4qtHJ20if3PwJwliLDPCEz8c1Gy4xt6bT7oMSBVIrh&variables_values=$otp&route=otp&numbers=$mobilenumber';

      Response response = await GetConnect().get(url);

      if (response.status.hasError) {
        Get.snackbar("Error", "Failed to send OTP, please try again", colorText: Colors.red);
        return;
      }

      if (response.body != null && response.body['message'] != null && response.body['message'][0] == 'SMS sent successfully.') {
        otpFieldShow = true;
        otpsend = otp;
        Get.snackbar("Success", 'OTP sent successfully', colorText: Colors.green);
      } else {
        Get.snackbar("Error", 'Failed to send OTP', colorText: Colors.red);
      }
    } catch (e) {
      print('Error sending OTP: $e');
      Get.snackbar("Error", "An error occurred while sending OTP", colorText: Colors.red);
    } finally {
      isSendingOtp = false;
      update();
    }
  }

  Future<void> loginWithPhone() async {
    try {
      String phoneNumber = LoginNumber.text;
      if (phoneNumber.isNotEmpty) {
        User? user = await getUserByPhoneNumber(phoneNumber);
        if (user != null) {
          loginUser.value = user; // Update observable user
          box.write('loginUser', user.toJson());
          LoginNumber.clear();
          Get.to(const HomePage());
          Get.snackbar("Success", "Login Successful", colorText: Colors.green);
        } else {
          Get.snackbar("Error", "User not found, please register", colorText: Colors.red);
        }
      } else {
        Get.snackbar("Error", "Please enter a phone number", colorText: Colors.red);
      }
    } catch (error) {
      print('Failed to login: $error');
      Get.snackbar("Error", "Failed to login", colorText: Colors.red);
    }
  }

  Future<User?> fetchUserDetails({String? userId, String? phoneNumber}) async {
    try {
      QuerySnapshot querySnapshot;

      // Fetch by userId
      if (userId != null) {
        querySnapshot = await usercollection
            .where('id', isEqualTo: userId)
            .limit(1)
            .get();
      }
      // Fetch by phoneNumber
      else if (phoneNumber != null) {
        querySnapshot = await usercollection
            .where('number', isEqualTo: int.tryParse(phoneNumber))
            .limit(1)
            .get();
      } else {
        throw Exception("Either userId or phoneNumber must be provided.");
      }

      if (querySnapshot.docs.isNotEmpty) {
        var userDoc = querySnapshot.docs.first;
        var userData = userDoc.data() as Map<String, dynamic>;
        return User.fromJson(userData);
      } else {
        print("No user found with the provided details.");
        return null;
      }
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }
}

