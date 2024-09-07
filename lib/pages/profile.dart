import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:TrendyFeet/controller/login_controller.dart';
import 'package:TrendyFeet/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  final LoginController loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to the edit profile page
              // Get.to(() => const EditProfilePage());
            },
          ),
        ],
      ),
      body: Obx(() {
        final user = loginController.loginUser.value;

        if (user == null) {
          return Center(child: CircularProgressIndicator());
        }
        Future<void> _showLogoutConfirmationDialog() async {
          return showDialog(
            context: Get.context!,
            builder: (context) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Do you really want to logout?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Get.back();
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    GetStorage box = GetStorage();
                    box.erase();
                    Get.offAll(() => LoginPage());
                  },
                ),
              ],
            ),
          );
        }

        String capitalizeFirstLetter(String text) {
          return text.isEmpty ? text : text[0].toUpperCase() + text.substring(1).toLowerCase();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Hi ${capitalizeFirstLetter(user.name ?? 'User')}!',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade300,
                child: Icon(Icons.person, size: 50, color: Colors.grey.shade800),
              ),
              const SizedBox(height: 8),
              Text(
                user.number.toString(),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20),
              Divider(),
              _buildProfileOption(Icons.store, 'My Stores'),
              Divider(),
              _buildProfileOption(Icons.support, 'Support'),
              Divider(),
              _buildProfileOption(Icons.notifications, 'Push Notifications',
                trailing: Switch(
                  value: true,
                  onChanged: (val) {
                    // Handle change
                  },
                ),
              ),
              Divider(),
              _buildProfileOption(Icons.face, 'Face ID',
                trailing: Switch(
                  value: true,
                  onChanged: (val) {
                    // Handle change
                  },
                ),
              ),
              Divider(),
              _buildProfileOption(Icons.lock, 'PIN Code'),
              Divider(),
              _buildProfileOption(Icons.logout, 'Logout', color: Colors.red, onTap: () {
                _showLogoutConfirmationDialog();
              }),
              SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }


  Widget _buildProfileOption(IconData icon, String title, {Widget? trailing, VoidCallback? onTap, Color color = Colors.black}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 18, color: color),
      onTap: onTap,
    );
  }
}
