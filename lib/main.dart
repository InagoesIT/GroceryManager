import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocery_manager/controllers/navigation_controller.dart';
import 'package:grocery_manager/controllers/product_categories_controller.dart';
import 'package:grocery_manager/models/pantry_item_model.dart';
import 'package:grocery_manager/services/notifications_service.dart';
import 'package:grocery_manager/views/pantry_view.dart';

import 'controllers/products_controller.dart';
import 'models/grocery_model.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  GroceryManager.createControllers();
  runApp(const GroceryManager());
}

class GroceryManager extends StatelessWidget {
  const GroceryManager({super.key});

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
