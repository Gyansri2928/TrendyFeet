import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:TrendyFeet/controller/login_controller.dart';

import 'Register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (ctrl) {
      return Scaffold(
        body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blueGrey[50],
          ),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Welcome Back",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.phone,
                controller: ctrl.LoginNumber,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.phone_android_sharp),
                    labelText: 'Mobile Number',
                    hintText: "Enter your mobile number"
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    ctrl.loginWithPhone();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: const Text("Login")
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    Get.to(const Register_page());
                  },
                  child: Text("Register new account")
              )
            ],
          ),
        ),
      );
    });
  }
}
