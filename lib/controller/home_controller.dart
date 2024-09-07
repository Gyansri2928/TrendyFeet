import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product/product.dart';
import '../models/product_category/product_category.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;
  late CollectionReference categoryCollection;

  var products = <Product>[].obs; // RxList for reactive updates
  var productfromUI = <Product>[].obs; // RxList for reactive updates
  var productCategory = <ProductCategory>[].obs; // RxList for reactive updates
  var selectedIndex = 0.obs; // Observable for selected index

  @override
  Future<void> onInit() async {
    productCollection = firestore.collection('products');
    categoryCollection = firestore.collection('Category');
    await fetchproducts();
    await fetchcategory();
    super.onInit();
  }


  // Method to change the selected index
  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
  fetchproducts() async {
    try {
      QuerySnapshot productsnapshot = await productCollection.get();
      final List<Product> retrieveproduct = productsnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      products.assignAll(retrieveproduct);
      productfromUI.assignAll(products);
      Get.snackbar('Success', "Products fetched successfully",
          colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }

  fetchcategory() async {
    try {
      QuerySnapshot categorysnapshot = await categoryCollection.get();
      final List<ProductCategory> retrieveCategory = categorysnapshot.docs
          .map((doc) =>
          ProductCategory.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      productCategory.assignAll(retrieveCategory);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }

  filterByCategory(String category) {
    if (category.isEmpty) {
      productfromUI.assignAll(products);
    } else {
      productfromUI.assignAll(
        products.where((product) => product.category == category).toList(),
      );
    }
  }

  filterByBrand(List<String> brands) {
    if (brands.isEmpty) {
      productfromUI.assignAll(products);
    } else {
      List<String> lowerCaseBrands = brands.map((brand) => brand.toLowerCase()).toList();
      productfromUI.assignAll(
        products.where((product) => lowerCaseBrands.contains(product.brand?.toLowerCase())).toList(),
      );
    }
  }
  void clearCategoryFilter() {
    // Clear the filtered products or reset to show all products
    productfromUI.assignAll(products); // Assuming allProducts holds the complete product list
    update(); // Trigger UI update
  }

  void sortByPrice({required bool ascending}) {
    print("Sorting by price: ${ascending ? 'Low to High' : 'High to Low'}"); // Debugging line
    List<Product> sortedProducts = List<Product>.from(productfromUI);
    sortedProducts.sort((a, b) {
      if (a.price == null || b.price == null) {
        return 0; // Handle cases where price might be null
      }
      return ascending
          ? a.price!.compareTo(b.price!)
          : b.price!.compareTo(a.price!);
    });
    productfromUI.assignAll(sortedProducts); // Ensure you update the observable list
    update(); // Notify listeners
  }

}