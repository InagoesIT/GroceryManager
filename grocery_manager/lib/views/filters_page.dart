import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_manager/controllers/product_categories_controller.dart';
import 'package:grocery_manager/models/grocery.dart';
import 'package:grocery_manager/models/product.dart';
import 'package:grocery_manager/views/my_groceries.dart';
import 'package:grocery_manager/views/my_pantry.dart';

import '../controllers/my_products_controller.dart';

class FiltersPage<T extends Product> extends StatelessWidget {
  final MyProductsController<T> myProductsController =
      Get.find<MyProductsController<T>>();
  final ProductsCategoryController productsCategoryController =
      Get.find<ProductsCategoryController>();
  static const String NO_CATEGORY = "";
  RxString currentFilter = FiltersPage.NO_CATEGORY.obs;

  FiltersPage({super.key});

  @override
  Widget build(BuildContext context) {
    currentFilter = myProductsController.currentFilter;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Filter the items by category'),
            ),
            body: getBody(context)));
  }

  Widget getBody(BuildContext context) {
    int categoriesSize = productsCategoryController.getListSize();
    return Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
            child: Column(
          children: getCategories(categoriesSize, context) + [getButtons()],
        )));
  }

  List<Widget> getCategories(categoriesSize, context) {
    List<Widget> categoryItems = List.empty(growable: true);
    for (int index = 0; index < categoriesSize; index++) {
      categoryItems.add(getCategoryItem(index));
    }
    return categoryItems;
  }

  Widget getCategoryItem(int index) {
    String category = productsCategoryController.getCategory(index)!;
    return Obx(() => (RadioListTile<String>(
          value: category,
          onChanged: (newFilter) => {
            if (newFilter != null)
              {
                currentFilter.value = newFilter,
              }
          },
          groupValue: currentFilter.value,
          title: Text(category),
        )));
  }

  Widget getButtons() {
    return Row(
      children: [
        getSpaceBetweenElements(isVertical: true, multiplier: 3),
        getDisableFiltersButton(),
        getSpaceBetweenElements(isVertical: false),
        getApplyFiltersButton()
      ],
    );
  }

  SizedBox getSpaceBetweenElements(
      {required bool isVertical, double multiplier = 2}) {
    if (isVertical) {
      return SizedBox(height: 25 * multiplier);
    }
    return SizedBox(width: 25 * multiplier);
  }

  OutlinedButton getDisableFiltersButton() {
    return OutlinedButton(
        onPressed: deleteFilter, child: const Text("Disable filters"));
  }

  void deleteFilter() {
    currentFilter.value = FiltersPage.NO_CATEGORY;
    myProductsController.currentFilter.value = currentFilter.value;
    redirect();
  }

  ElevatedButton getApplyFiltersButton() {
    return ElevatedButton(
        onPressed: applyFilter, child: const Text("Apply filters"));
  }

  void applyFilter() {
    myProductsController.currentFilter.value = currentFilter.value;
    redirect();
  }

  void redirect() {
    myProductsController.filterProducts();
    Get.back();
  }
}
