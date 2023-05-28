import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_manager/controllers/my_products_controller.dart';
import 'package:grocery_manager/models/pantry_item.dart';
import 'package:grocery_manager/views/base_views/my_products.dart';
import 'package:grocery_manager/views/my_pantry_item.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/product_categories_controller.dart';

class MyPantry extends MyProducts<PantryItem> {
  @override
  final NavigationController? navigationController =
      Get.find<NavigationController>();
  @override
  final MyProductsController<PantryItem>? myProductsController =
      Get.find<MyProductsController<PantryItem>>();
  @override
  final String? pageTitle = "My Pantry";
  @override
  final bool? isGrocery = false;
  @override
  final ProductsCategoryController productCategoriesController =
      Get.find<ProductsCategoryController>();

  MyPantry({super.key});

  @override
  Obx? getProductCheckbox(
      MyProductsController<PantryItem> myProductsController, int index) {
    return null;
  }

  @override
  void getToMyProduct(int index) {
    Get.to(MyPantryItem(index: index));
  }

  @override
  void getToNewMyProduct() {
    Get.to(MyPantryItem());
  }

  @override
  List<PopupMenuEntry<int>> getMenuItems(context) {
    return [getFilterMenuOption()];
  }

  @override
  void handleMenu(selectedIndex) {
    if (selectedIndex == MyProducts.FILTER_OPTION_INDEX) {
      redirectToFilterPage();
    }
  }
}
