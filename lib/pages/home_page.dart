import 'package:TrendyFeet/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:TrendyFeet/controller/home_controller.dart';
import 'package:TrendyFeet/pages/product_detail.dart';
import 'package:TrendyFeet/widget/multi_select_dropdown.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shimmer/shimmer.dart';

import '../controller/purchase_controller.dart';
import '../models/product_category/product_category.dart';
import '../widget/drop_down.dart';
import 'cart_page.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('Exit'),
        content: const Text('Do you really want to exit the app?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Get.back(result: false);
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    )) ?? false;
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

  @override
  Widget build(BuildContext context) {
    final PurchaseController purchaseController = Get.find<PurchaseController>();

    return GetBuilder<HomeController>(builder: (ctrl) {
      List<ProductCategory> orderedCategories = List.from(ctrl.productCategory)
        ..sort((a, b) => a.isSelected ? -1 : 1);

      return WillPopScope(
        onWillPop: _onWillPop,
        child: RefreshIndicator(
          onRefresh: () async {
            ctrl.fetchproducts();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "FootWare Store",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                Obx(() {
                  var len = purchaseController.cartItems.length;
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {
                          Get.to(const CartScreen());
                        },
                      ),
                      if (len > 0)
                        Positioned(
                          right: 5,
                          top: 5,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$len',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
                IconButton(
                  onPressed: () {
                    _showLogoutConfirmationDialog();
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            drawer: Drawer(
              child: Column(
                children: [
                  Container(
                    color: Colors.pink.shade50,
                    child: const DrawerHeader(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/drawer_background.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Menu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home, color:  Colors.black),
                    title: const Text('Home', style: TextStyle(color: Colors.black)),
                    onTap: () {
                      Get.back();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person, color:  Colors.black),
                    title: const Text('Profile', style: TextStyle(color: Colors.black)),
                    onTap: () {
                      Get.to(() => ProfilePage());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color:  Colors.black),
                    title: Text('Settings', style: TextStyle(color: Colors.black)),
                    onTap: () {
                      Get.back();
                    },
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 25, left: 10),
                    child: ListTile(
                      leading: Icon(Icons.logout, color:  Colors.black),
                      title: Text('Logout', style: TextStyle(color: Colors.black)),
                      onTap: () {
                        _showLogoutConfirmationDialog();
                      },
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: DropDown(
                          items: ['Rs. Low to High', 'Rs. High to Low'],
                          hnttxt: "Sort items",
                          onSelected: (selected) {
                            ctrl.sortByPrice(ascending: selected == 'Rs. Low to High');
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: MultiSelDropDown(
                          items: ['Adidas', 'Reebok', 'Bata', 'Puma'],
                          onSelectionChanged: (selectedItems) {
                            ctrl.filterByBrand(selectedItems);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: orderedCategories.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (orderedCategories[index].isSelected) {
                              orderedCategories[index].isSelected = false;
                              ctrl.clearCategoryFilter();
                            } else {
                              for (var category in orderedCategories) {
                                category.isSelected = false;
                              }
                              orderedCategories[index].isSelected = true;
                              ctrl.filterByCategory(orderedCategories[index].name ?? " ");
                            }
                            ctrl.update();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Chip(
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: orderedCategories[index].isSelected
                                      ? Colors.blue
                                      : Colors.grey[400]!,
                                ),
                              ),
                              label: Text(
                                orderedCategories[index].name ?? 'No name',
                                style: TextStyle(
                                  color: orderedCategories[index].isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              backgroundColor: orderedCategories[index].isSelected
                                  ? Colors.blue
                                  : Colors.grey[200],
                            ),
                          ),
                        );
                      }),
                ),
                Expanded(
                  child: GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.75),
                      itemCount: ctrl.productfromUI.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: InkWell(
                            onTap: () {
                              Get.to(ProductDescriptionPage(
                                imageUrl: ctrl.productfromUI[index].image ?? 'url',
                                name: ctrl.productfromUI[index].name ?? 'No name',
                                price: ctrl.productfromUI[index].price ?? 00,
                                description: ctrl.productfromUI[index].description ?? '',
                                product: ctrl.productfromUI[index],
                              ));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ctrl.productfromUI[index].image == null
                                      ? Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(12)),
                                      ),
                                    ),
                                  )
                                      : ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12)),
                                    child: Image.network(
                                      ctrl.productfromUI[index].image!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ctrl.productfromUI[index].name ?? 'No name',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '₹${ctrl.productfromUI[index].price ?? 00}',
                                        style: const TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        '20% OFF',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
