import 'package:flutter/src/material/popup_menu.dart';
import 'package:get/get.dart';
import 'package:grocery_manager/controllers/my_pantry_controller.dart';
import 'package:grocery_manager/views/base_views/my_products.dart';
import 'package:grocery_manager/views/my_pantry_item.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/product_categories_controller.dart';

class MyPantry extends MyProducts {
  @override
  final NavigationController? navigationController =
      Get.find<NavigationController>();
  @override
  final dynamic myProductsController = Get.find<MyPantryController>();
  @override
  final String? pageTitle = "My Pantry";
  @override
  final bool? isGrocery = false;
  @override
  final dynamic productCategoriesController =
      Get.find<ProductsCategoryController>();

  MyPantry({super.key});

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
