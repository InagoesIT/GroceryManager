import 'package:flutter/material.dart';
import 'package:flutter/src/material/popup_menu.dart';
import 'package:get/get.dart';
import 'package:grocery_manager/controllers/my_products_controller.dart';
import 'package:grocery_manager/models/grocery.dart';
import 'package:grocery_manager/views/base_views/my_products.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/product_categories_controller.dart';
import 'my_grocery.dart';

class MyGroceries extends MyProducts<Grocery> {
  @override
  final MyProductsController<Grocery>? myProductsController =
      Get.find<MyProductsController<Grocery>>();
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

  MyGroceries({super.key});

  @override
  void getToMyProduct(int index) {
    Get.to(MyGrocery(index: index));
  }

  @override
  void getToNewMyProduct() {
    Get.to(MyGrocery());
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

  @override
  Obx? getProductCheckbox(
      MyProductsController<Grocery> myProductsController, int index) {
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
  TextDecoration getTextDecoration(Grocery product) {
    return product.isBought.value
        ? TextDecoration.lineThrough
        : TextDecoration.none;
  }
}
