import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:products_manager/controllers/navigation_controller.dart';
import 'package:products_manager/controllers/product_categories_controller.dart';
import 'package:products_manager/models/pantry_item_model.dart';
import 'package:products_manager/services/notifications_service.dart';
import 'package:products_manager/views/pantry_view.dart';

import 'controllers/products_controller.dart';
import 'models/grocery_model.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  ProductsManager.createControllers();
  runApp(const ProductsManager());
}

class ProductsManager extends StatelessWidget {
  const ProductsManager({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery Manager',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PantryView(),
    );
  }

  static void createControllers() {
    Get.put(ProductsController<GroceryModel>(
        createProductFunction: () => GroceryModel(), key: "groceries"));
    Get.put(ProductsController<PantryItemModel>(
        createProductFunction: () => PantryItemModel(), key: "pantry"));
    Get.put(NavigationController());
    Get.put(ProductsCategoryController());
    Get.put(NotificationsService());
  }
}
