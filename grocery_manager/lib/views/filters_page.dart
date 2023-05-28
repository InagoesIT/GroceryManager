import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_manager/controllers/product_categories_controller.dart';
import 'package:grocery_manager/models/product.dart';

import '../controllers/my_products_controller.dart';

class FiltersPage<T extends Product> extends StatelessWidget {
  final MyProductsController<T> myProductsController =
      Get.find<MyProductsController<T>>();
  final ProductsCategoryController productsCategoryController =
      Get.find<ProductsCategoryController>();
  static const String NO_CATEGORY = "";

  FiltersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: const Text('Filter the items by category')),
            body: getBody(context)));
  }

  Widget getBody(BuildContext context) {
    int categoriesSize = productsCategoryController.getListSize();

    return Padding(
        padding: const EdgeInsets.all(25),
        child: ListView.builder(
          itemCount: categoriesSize,
          itemBuilder: (context, index) =>
              getCategoryItem(productsCategoryController.getCategory(index)!),
        ));
  }

  Widget getCategoryItem(String category) {
    return Obx(() => (RadioListTile<String>(
          value: category,
          onChanged: (newFilter) => {
            if (newFilter != null)
              {
                myProductsController.currentFilter.value = newFilter,
              }
          },
          groupValue: myProductsController.currentFilter.value,
          title: Text(category),
        )));
  }
}
