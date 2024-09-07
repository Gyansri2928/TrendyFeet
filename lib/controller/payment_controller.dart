import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:TrendyFeet/controller/purchase_controller.dart';
import '../models/orders/orders.dart';
import '../models/product/product.dart';

class PaymentController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;

  TextEditingController addressController = TextEditingController();
  String transactionId = '1666'; // Example transaction ID, replace with actual data
  RxString selectedPaymentMethod = ''.obs; // Store the selected payment method as an observable

  // Create an instance of GetStorage
  final GetStorage box = GetStorage();

  @override
  void onInit() {
    orderCollection = firestore.collection('orders');
    super.onInit();
  }

  void updatePaymentMethod(String paymentMethod) {
    if (selectedPaymentMethod.value == paymentMethod) {
      selectedPaymentMethod.value = ''; // Deselect if already selected
    } else {
      selectedPaymentMethod.value = paymentMethod;
    }
  }

  Future<void> saveOrderToFirestore() async {
    print("Starting saveOrderToFirestore...");

    String address = addressController.text;
    double totalPrice = Get.find<PurchaseController>().totalPrice;

    List<dynamic>? storedCartItems = box.read<List<dynamic>>('cartItems');
    List<Product> cartItems = storedCartItems != null
        ? storedCartItems.map((item) => Product.fromJson(item)).toList()
        : [];

    try {
      // Ensure all necessary fields are valid (add validation checks if needed)

      if (address.isNotEmpty && cartItems.isNotEmpty) {
        DateTime now = DateTime.now();
        DocumentReference doc = orderCollection.doc();

        // Create a map to store product quantities
        Map<String, int> productQuantities = {};
        for (Product product in cartItems) {
          productQuantities[product.id.toString()] = product.quantity ?? 1; // Use product.quantity if available, default to 1
        }

        Orders order = Orders(
          totalPrice: totalPrice,
          deliveryAddress: address,
          paymentMethod: selectedPaymentMethod.value, // Use the selected payment method
          orderPlacedTime: now,
          products: cartItems,
          productQuantities: productQuantities,
        );

        await doc.set(order.toJson());
        print("Order saved successfully with ID: ${doc.id}");

        addressController.clear();
        box.remove('cartItems'); // Clear cart data from GetStorage
        transactionId = '';

        Get.snackbar(
            'Success',
            'Your order has been placed successfully.',
            colorText: Colors.green);

      } else {
        showErrorSnackbar('Please enter a delivery address and add items to the cart.');
      }
    } catch (e) {
      print('Failed to save order: $e');
    }
  }

  // ... (existing code for getUserId and getUserDetails)

  void showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      colorText: Colors.red,
    );
  }


  Future<void> testFirestore() async {
    try {
      DocumentReference doc = orderCollection.doc();
      await doc.set({'test': 'value'});
      print('Test document written successfully');
    } catch (e) {
      print('Failed to write test document: $e');
    }
  }
}
