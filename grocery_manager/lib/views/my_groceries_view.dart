import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_manager/controllers/my_products_controller.dart';
import 'package:grocery_manager/models/grocery_model.dart';
import 'package:grocery_manager/views/base_views/my_products_view.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/product_categories_controller.dart';
import 'my_grocery_view.dart';

class MyGroceriesView extends MyProductsView<GroceryModel> {
  @override
  final MyProductsController<GroceryModel>? myProductsController =
      Get.find<MyProductsController<GroceryModel>>();
  @override
  final String? pageTitle = "My Groceries";
  @override
  final bool? isGrocery = true;
  @override
  final ProductsCategoryController productCategoriesController =
      Get.find<ProductsCategoryController>();
  @override
  final NavigationController? navigationController =
      Get.find<NavigationController>();

  MyGroceriesView({super.key});

  @override
  void getToMyProduct(int index) {
    Get.to(MyGroceryView(index: index));
  }

  @override
  void getToNewMyProduct() {
    Get.to(MyGroceryView());
  }

  @override
  List<PopupMenuEntry<int>> getMenuItems(context) {
    return [getFilterMenuOption()];
  }

  @override
  void handleMenu(selectedIndex) {
    if (selectedIndex == MyProductsView.FILTER_OPTION_INDEX) {
      redirectToFilterPage();
    }
  }

  @override
  Obx? getProductCheckbox(
      MyProductsController<GroceryModel> myProductsController, int index) {
    var product = myProductsController.getProduct(index);

    return Obx(() => Checkbox(
          value: product!.isBought.value,
          onChanged: (isEnabled) {
            product.isBought.value = !product.isBought.value;
            if (product.isBought.value) {
              myProductsController.removeProductWithIndex(index);
              myProductsController.addProduct(product);
            }
          },
        ));
  }

  @override
  TextDecoration getTextDecoration(GroceryModel product) {
    return product.isBought.value
        ? TextDecoration.lineThrough
        : TextDecoration.none;
  }
}
