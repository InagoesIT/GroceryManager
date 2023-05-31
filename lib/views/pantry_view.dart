import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_manager/controllers/products_controller.dart';
import 'package:grocery_manager/models/pantry_item_model.dart';
import 'package:grocery_manager/services/notifications_service.dart';
import 'package:grocery_manager/views/base_views/products_view.dart';
import 'package:grocery_manager/views/pantry_item_view.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/product_categories_controller.dart';

class PantryView extends ProductsView<PantryItemModel> {
  @override
  final NavigationController? navigationController =
      Get.find<NavigationController>();
  @override
  final ProductsController<PantryItemModel>? productsController =
      Get.find<ProductsController<PantryItemModel>>();
  @override
  final String? pageTitle = "Pantry";
  @override
  final bool? isGrocery = false;
  @override
  final ProductsCategoryController productCategoriesController =
      Get.find<ProductsCategoryController>();
  final NotificationsService notificationsService =
      Get.find<NotificationsService>();
  static const Color TILE_EXPIRING_COLOR = Color.fromARGB(255, 221, 141, 168);

  PantryView({super.key});

  @override
  Obx? getProductCheckbox(
      ProductsController<PantryItemModel> productsController, int index) {
    return null;
  }

  @override
  void getToProduct(int index) {
    Get.to(PantryItemView(index: index));
  }

  @override
  void getToNewProduct() {
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

  bool isExpiring(PantryItemModel product) {
    if (product.expiryDate.value.compareTo(PantryItemModel.defaultDate) == 0) {
      return false;
    }
    DateTime productExpirationNotification = product.expiryDate.value
        .subtract(Duration(days: product.daysBeforeNotify.value));
    if (productExpirationNotification.compareTo(DateTime.now()) <= 0) {
      return true;
    }
    return false;
  }

  @override
  Color getProductTileColor(PantryItemModel product) {
    if (isExpiring(product)) {
      return TILE_EXPIRING_COLOR;
    }
    return Colors.white;
  }
}
