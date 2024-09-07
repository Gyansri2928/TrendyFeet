import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Import GetStorage

import '../models/product/product.dart';
import 'home_controller.dart';

class PurchaseController extends GetxController {
  late CollectionReference orderCollection;

  TextEditingController addressController = TextEditingController();
  double orderPrice = 0;
  String itemName = '';
  String orderAddress = '';
  var cartItems = <Product>[].obs;
  var selectedSize = 6.obs;

  // Create an instance of GetStorage
  final GetStorage box = GetStorage();

  // Observable list for cart items

  @override
  void onInit() {
    super.onInit();
    // Load cart items from GetStorage when the controller is initialized
    loadCartItems();
  }

  void loadCartItems() {
    List<dynamic>? storedCartItems = box.read<List<dynamic>>('cartItems');
    if (storedCartItems != null) {
      cartItems.value = storedCartItems
          .map((item) => Product.fromJson(item))
          .toList();
    }
  }

  void saveCartItems() {
    List<Map<String, dynamic>> cartItemsJson = cartItems
        .map((item) => item.toJson())
        .toList();
    box.write('cartItems', cartItemsJson);
  }


  double get actualPrice{
    return cartItems.fold(0, (sum, item) => sum + (item.price! * item.quantity!));
  }

  //20% discount on every item
  double get totalDiscount{
    return actualPrice * 0.2;
  }

  double get totalPriceAfterDiscount{
    return actualPrice - totalDiscount;
  }

  double get gstAmount {
    return totalPriceAfterDiscount * 0.05; // 18% GST
  }

  double get finalTotal {
    return totalPriceAfterDiscount + gstAmount;
  }

  int generateRandomInt({int min = 1000, int max = 9999}) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }

  // Add to cart
  HomeController homeController = Get.find<HomeController>();

  Future<void> addToCart({required String? productId}) async {
    try {
      if (productId == null) {
        Get.snackbar('Error', 'Product ID is null', colorText: Colors.red);
        return;
      }

      final product = homeController.products
          .firstWhere((p) => p.id == productId, orElse: () => Product(
        id: '',
        name: '',
        price: 0.0,
        description: '',
        image: '',
        category: '',
        brand: '',
      ));

      if (product.id!.isNotEmpty) {
        // Add quantity (default to 1) when adding to cart
        final newProduct = product.copyWith(quantity: 1);

        final existingProductIndex = cartItems.indexWhere((p) => p.id == product.id);

        if (existingProductIndex >= 0) {
          final existingProduct = cartItems[existingProductIndex];
          final updatedQuantity = existingProduct.quantity! + 1;
          if (updatedQuantity > 0) {
            final updatedProduct = existingProduct.copyWith(
                quantity: updatedQuantity);
            cartItems[existingProductIndex] = updatedProduct;
          } else {
            cartItems.removeAt(existingProductIndex);
          }
        } else {
          cartItems.add(newProduct);
        }
        cartItems.refresh();
        saveCartItems(); // Save updated cart items to GetStorage
      } else {
        Get.snackbar('Error', 'Product not found', colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product to cart: $e', colorText: Colors.red);
    }
  }
  void updateSize(int size) {
    selectedSize.value = size;
  }

  Future<void> removeFromCart(int index) async {
    try {
      cartItems.removeAt(index);
      saveCartItems(); // Save updated cart items to GetStorage
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove product from cart: $e', colorText: Colors.red);
    }
  }
  void clearCart() {
    cartItems.clear(); // Clear all items from the cart
    saveCartItems(); // Update the stored cart in GetStorage
    Get.snackbar('Cart Cleared', 'All items have been removed from your cart.', colorText: Colors.green);
  }
  double get totalPrice {
    return cartItems.fold(
        0, (sum, item) => sum + (item.price ?? 0) * (item.quantity ?? 1));
  }

  Future<void> updateProductQuantity(int index, int newQuantity) async {
    if (newQuantity <= 0) {
      removeFromCart(index);
      return;
    }

    try {
      Product product = cartItems[index];
      cartItems[index] = product.copyWith(quantity: newQuantity);
      saveCartItems(); // Save updated cart items to GetStorage
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product quantity: $e', colorText: Colors.red);
    }
  }
}
