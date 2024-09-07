import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:TrendyFeet/pages/home_page.dart';
import 'package:slider_button/slider_button.dart';
import '../controller/purchase_controller.dart';
import 'ordersuccess.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PurchaseController ctrl = Get.find<PurchaseController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Get.to((const HomePage())),
              icon: const Icon(Icons.add_shopping_cart)),
          IconButton(
              onPressed: () => ctrl.clearCart(),
              icon: const Icon(Icons.delete_rounded))
        ],
      ),
      body: Obx(() {
        return ctrl.cartItems.isEmpty
            ? Center(
          child: Text(
            "Your cart is empty!",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: ctrl.cartItems.length,
                    itemBuilder: (context, index) {
                      final product = ctrl.cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          leading: Image.network(
                            product.image ?? '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            product.name ?? 'Unknown Product',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text("Rs ${product.price}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                    Icons.remove_circle_outline),
                                onPressed: () async {
                                  if (product.quantity! > 1) {
                                    await ctrl.updateProductQuantity(
                                        index, product.quantity! - 1);
                                  } else {
                                    ctrl.cartItems.removeAt(index);
                                  }
                                },
                              ),
                              AnimatedFlipCounter(
                                value: product.quantity ?? 0,
                                padding: const EdgeInsets.all(5),
                                textStyle: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                                duration:
                                const Duration(milliseconds: 300),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () async {
                                  await ctrl.updateProductQuantity(
                                      index, product.quantity! + 1);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                DottedBorder(
                  color: Colors.grey,
                  dashPattern: [6, 3],
                  borderType: BorderType.RRect,
                  borderPadding:
                  const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  radius: const Radius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Actual Price:",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "₹ ${ctrl.actualPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Discount (20%):",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green),
                            ),
                            Text(
                              "- ₹ ${ctrl.totalDiscount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "GST:",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green),
                            ),
                            Text(
                              "+ ₹ ${ctrl.gstAmount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 20),
                          child: DottedBorder(
                            color: Colors.grey,
                            dashPattern: [6, 3],
                            child: Container(
                              height: 0,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Price",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₹ ${ctrl.finalTotal.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo, Colors.blueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: SliderButton(
                      action: () async{
                        Get.snackbar(
                          "Proceeding to Checkout",
                          "Your payment is being processed",
                          colorText: Colors.green,

                        );
                        Get.to(() => OrderPlacedPage());
                        return false;
                      },
                      alignLabel: Alignment.center,
                      label: const Text(
                        "Proceed to CheckOut",
                        style:
                        TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      icon: const Icon(
                        Icons.shopping_cart_checkout_rounded,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.transparent,
                      buttonColor: Colors.transparent,
                      height: 60,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
