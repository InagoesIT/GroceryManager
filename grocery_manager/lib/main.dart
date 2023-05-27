import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocery_manager/controllers/my_groceries_controller.dart';
import 'package:grocery_manager/controllers/my_pantry_controller.dart';
import 'package:grocery_manager/controllers/navigation_controller.dart';
import 'package:grocery_manager/controllers/product_categories_controller.dart';
import 'package:grocery_manager/views/my_pantry.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void createControllers() {
    Get.put(MyGroceriesController());
    Get.put(MyPantryController());
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
