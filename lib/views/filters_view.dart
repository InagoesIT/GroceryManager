import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:products_manager/controllers/product_categories_controller.dart';
import 'package:products_manager/models/product_model.dart';

import '../controllers/products_controller.dart';

class FiltersView<T extends ProductModel> extends StatelessWidget {
  final ProductsController<T> productsController =
      Get.find<ProductsController<T>>();
  final ProductsCategoryController productsCategoryController =
      Get.find<ProductsCategoryController>();
  static const String NO_CATEGORY = "";
  RxString currentFilter = FiltersView.NO_CATEGORY.obs;

  FiltersView({super.key});

  @override
  Widget build(BuildContext context) {
    currentFilter = productsController.currentFilter;
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
    currentFilter.value = FiltersView.NO_CATEGORY;
    productsController.currentFilter.value = currentFilter.value;
    redirect();
  }

  ElevatedButton getApplyFiltersButton() {
    return ElevatedButton(
        onPressed: applyFilter, child: const Text("Apply filters"));
  }

  void applyFilter() {
    productsController.currentFilter.value = currentFilter.value;
    redirect();
  }

  void redirect() {
    productsController.filterProducts();
    Get.back();
  }
}
