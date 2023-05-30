import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_manager/controllers/products_controller.dart';
import 'package:grocery_manager/models/grocery_model.dart';
import 'package:grocery_manager/views/base_views/products_view.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/product_categories_controller.dart';
import 'grocery_view.dart';

class GroceriesView extends ProductsView<GroceryModel> {
  @override
  final ProductsController<GroceryModel>? productsController =
      Get.find<ProductsController<GroceryModel>>();
  @override
  final String? pageTitle = "Groceries";
  @override
  final bool? isGrocery = true;
  @override
  final ProductsCategoryController productCategoriesController =
      Get.find<ProductsCategoryController>();
  @override
  final NavigationController? navigationController =
      Get.find<NavigationController>();
  static const int TRANSFER_TO_PANTRY_INDEX = 1;

  GroceriesView({super.key});

  @override
  void getToProduct(int index) {
    Get.to(GroceryView(index: index));
  }

  @override
  void getToNewProduct() {
    Get.to(GroceryView());
  }

  @override
  List<PopupMenuEntry<int>> getMenuItems(context) {
    return [getFilterMenuOption(), getTransferToPantryOption()];
  }

  @override
  void handleMenu(selectedIndex) {
    if (selectedIndex == ProductsView.FILTER_OPTION_INDEX) {
      redirectToFilterPage();
    } else if (selectedIndex == GroceriesView.TRANSFER_TO_PANTRY_INDEX) {
      productsController!.transferToPantry();
    }
  }

  @override
  Obx? getProductCheckbox(
      ProductsController<GroceryModel> productsController, int index) {
    var product = productsController.getProduct(index);

    return Obx(() => Checkbox(
          value: product!.isBought.value,
          onChanged: (isEnabled) {
            product.isBought.value = !product.isBought.value;
            if (product.isBought.value) {
              productsController.removeProductWithIndex(index);
              productsController.addProduct(product);
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

  PopupMenuEntry<int> getTransferToPantryOption() {
    return const PopupMenuItem<int>(
        value: TRANSFER_TO_PANTRY_INDEX,
        child: ListTile(
          leading: Icon(Icons.shopping_cart_checkout_rounded),
          title: Text("Transfer items to pantry"),
          subtitle: Text("Transfer the bought items to pantry"),
        ));
  }
}
