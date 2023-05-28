import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocery_manager/controllers/navigation_controller.dart';
import 'package:grocery_manager/controllers/product_categories_controller.dart';
import 'package:grocery_manager/models/pantry_item.dart';
import 'package:grocery_manager/views/my_pantry.dart';

import 'controllers/my_products_controller.dart';
import 'models/grocery.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void createControllers() {
    Get.put(MyProductsController<Grocery>(
        createProductFunction: () => Grocery(), key: "my_groceries"));
    Get.put(MyProductsController<PantryItem>(
        createProductFunction: () => PantryItem(), key: "my_pantry"));
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
      home: MyPantry(),
    );
  }
}
