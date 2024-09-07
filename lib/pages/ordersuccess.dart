import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/payment_controller.dart';
import '../controller/purchase_controller.dart';
import '../utils/order_success_page.dart';

class OrderPlacedPage extends StatelessWidget {
  const OrderPlacedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController ctrl = Get.find<PaymentController>();
    final PurchaseController purchaseCtrl = Get.find<PurchaseController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueAccent, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Price:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "₹ ${purchaseCtrl.finalTotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Delivery Location",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ctrl.addressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your delivery address",
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              const Text(
                "Payment Options",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => PaymentOptionCard(
                icon: Icons.credit_card,
                title: "Credit/Debit Card",
                subtitle: "Pay with your credit or debit card.",
                paymentMethod: "Credit/Debit Card",
                isSelected: ctrl.selectedPaymentMethod.value == "Credit/Debit Card",
                onTap: (paymentMethod) {
                  ctrl.updatePaymentMethod(paymentMethod);
                },
              )),
              const SizedBox(height: 10),
              Obx(() => PaymentOptionCard(
                icon: Icons.account_balance_wallet,
                title: "Wallet",
                subtitle: "Pay using your digital wallet.",
                paymentMethod: "Wallet",
                isSelected: ctrl.selectedPaymentMethod.value == "Wallet",
                onTap: (paymentMethod) {
                  ctrl.updatePaymentMethod(paymentMethod);
                },
              )),
              const SizedBox(height: 10),
              Obx(() => PaymentOptionCard(
                icon: Icons.payment,
                title: "Cash on Delivery",
                subtitle: "Pay with cash upon delivery.",
                paymentMethod: "Cash on Delivery",
                isSelected: ctrl.selectedPaymentMethod.value == "Cash on Delivery",
                onTap: (paymentMethod) {
                  ctrl.updatePaymentMethod(paymentMethod);
                },
              )),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.indigo,
                  ),
                  child: const Text(
                    "Confirm Order",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  onPressed: () async {
                    if (ctrl.addressController.text.isNotEmpty) {
                      try {
                        // Save the order first
                        await ctrl.saveOrderToFirestore();

                        // Clear the cart after saving the order
                        purchaseCtrl.clearCart();

                        // Notify the user and navigate to the success page
                        Get.snackbar(
                          "Order Confirmed",
                          "Your order has been placed successfully.",
                          colorText: Colors.green,
                        );
                        // Navigate to OrderSuccessPage only after successful order placement
                        Get.offAll(() => OrderSuccessPage());
                      } catch (e) {
                        print("Error saving order: $e");
                        Get.snackbar(
                          "Error",
                          "Failed to place the order. Please try again.",
                          colorText: Colors.red,
                        );
                      }
                    } else {
                      Get.snackbar(
                        "Error",
                        "Please enter a delivery address.",
                        colorText: Colors.red,
                      );
                      // Don't navigate to the success page if the address is not provided
                    }
                  },

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String paymentMethod;
  final bool isSelected;
  final Function(String) onTap;

  const PaymentOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.paymentMethod,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: isSelected ? Colors.blue.shade100 : Colors.white,
      child: ListTile(
        leading: Icon(icon, size: 40, color: isSelected ? Colors.blue : Colors.black),
        title: Text(title, style: TextStyle(color: isSelected ? Colors.blue : Colors.black)),
        subtitle: Text(subtitle, style: TextStyle(color: isSelected ? Colors.blue : Colors.black)),
        onTap: () {
          onTap(paymentMethod);
        },
      ),
    );
  }
}
