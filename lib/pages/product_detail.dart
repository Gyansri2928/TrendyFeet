import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/purchase_controller.dart';
import '../pages/cart_page.dart';
import '../models/product/product.dart';

class ProductDescriptionPage extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;
  final String description;
  final Product? product;

  const ProductDescriptionPage({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.description,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final PurchaseController ctrl = Get.find<PurchaseController>();
    final List<int> sizes = [6, 7, 8, 9, 10]; // Example sizes

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 250,
                        margin: const EdgeInsets.only(top: 30),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 10),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: sizes.map((size) {
                      return GestureDetector(
                        onTap: () {
                          ctrl.updateSize(size); // Update selected size
                        },
                        child: Obx(() => Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ctrl.selectedSize.value == size ? Colors.blue : Colors.grey,
                            ),
                            color: ctrl.selectedSize.value == size ? Colors.blue[100] : Colors.transparent,
                          ),
                          child: Text(
                            size.toString(),
                            style: TextStyle(
                              color: ctrl.selectedSize.value == size ? Colors.blue : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Rs $price",
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    description,
                    style:  TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w400,
                      height: 1.5, // Improve readability
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.indigo,
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () async {
                  // Set default size before adding to cart
                  ctrl.updateSize(6);
                  await ctrl.addToCart(productId: product!.id.toString());
                  Get.to(() => CartScreen());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
