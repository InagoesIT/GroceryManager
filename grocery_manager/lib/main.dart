import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocery_manager/controllers/navigation_controller.dart';
import 'package:grocery_manager/controllers/product_categories_controller.dart';
import 'package:grocery_manager/models/pantry_item_model.dart';
import 'package:grocery_manager/views/my_pantry_view.dart';

import 'controllers/my_products_controller.dart';
import 'models/grocery_model.dart';

void main() async {
  await GetStorage.init();
  runApp(const GroceryManager());
}

class GroceryManager extends StatelessWidget {
  const GroceryManager({super.key});

  void createControllers() {
    Get.put(MyProductsController<GroceryModel>(
        createProductFunction: () => GroceryModel(), key: "my_groceries"));
    Get.put(MyProductsController<PantryItemModel>(
        createProductFunction: () => PantryItemModel(), key: "my_pantry"));
    Get.put(NavigationController());
    Get.put(ProductsCategoryController());
  }

  @override
  Widget build(BuildContext context) {
    createControllers();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery Manager',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyPantryView(),
    );
  }
}
