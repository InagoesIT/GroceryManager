import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_manager/controllers/my_products_controller.dart';
import 'package:grocery_manager/models/pantry_item_model.dart';
import 'package:grocery_manager/views/base_views/products_view.dart';
import 'package:grocery_manager/views/pantry_item_view.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/product_categories_controller.dart';

class PantryView extends ProductsView<PantryItemModel> {
  @override
  final NavigationController? navigationController =
      Get.find<NavigationController>();
  @override
  final MyProductsController<PantryItemModel>? myProductsController =
      Get.find<MyProductsController<PantryItemModel>>();
  @override
  final String? pageTitle = "My Pantry";
  @override
  final bool? isGrocery = false;
  @override
  final ProductsCategoryController productCategoriesController =
      Get.find<ProductsCategoryController>();

  PantryView({super.key});

  @override
  Obx? getProductCheckbox(
      MyProductsController<PantryItemModel> myProductsController, int index) {
    return null;
  }

  @override
  void getToMyProduct(int index) {
    Get.to(PantryItemView(index: index));
  }

  @override
  void getToNewMyProduct() {
    Get.to(PantryItemView());
  }

  @override
  List<PopupMenuEntry<int>> getMenuItems(context) {
    return [getFilterMenuOption()];
  }

  @override
  void handleMenu(selectedIndex) {
    if (selectedIndex == ProductsView.FILTER_OPTION_INDEX) {
      redirectToFilterPage();
    }
  }
}
