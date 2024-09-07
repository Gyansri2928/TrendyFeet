import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:TrendyFeet/controller/login_controller.dart';
import 'package:TrendyFeet/pages/login_page.dart';
import 'package:TrendyFeet/widget/otp_textfield.dart';

class Register_page extends StatelessWidget {
  const Register_page({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (ctrl) {
      return Scaffold(
        body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Create Your Account !!",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: ctrl.name,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.phone_android_sharp),
                    labelText: "Your Name",
                    hintText: "Enter your name"
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.phone,
                controller: ctrl.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.phone_android_sharp),
                    labelText: "Mobile Number",
                    hintText: "Enter your mobile number"
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              Otp_Textfield(
                    otpController: ctrl.otp,
                visible: ctrl.otpFieldShow,
                onComplete: (otp) {
                      ctrl.otpenter = int.tryParse(otp??'0000');
                },
                ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: ctrl.isSendingOtp
                      ? null  // Disable button while sending OTP
                      : () {
                    if (ctrl.otpFieldShow) {
                      ctrl.addUser();
                    } else {
                      ctrl.sendOtp();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: Text(ctrl.otpFieldShow ? "Register" : "Send OTP")
              ),
              TextButton(
                  onPressed: () {
                    Get.to(const LoginPage());
                  },
                  child: const Text("Already have an account? Login")
              )
            ],
          ),
        ),
      );
    });
  }
}
