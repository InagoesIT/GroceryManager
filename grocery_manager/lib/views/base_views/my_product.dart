import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_manager/controllers/product_categories_controller.dart';

abstract class MyProduct extends StatelessWidget {
  final dynamic product = null;
  final dynamic myProductsController = null;
  final int? index;
  final ProductsCategoryController productsCategoryController = Get.find();

  MyProduct({super.key, this.index});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: index == null
                  ? const Text('Add a new item')
                  : const Text('Update item'),
            ),
            body: getBody(context)));
  }

  Widget getBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: getProductElements(context) + getProductButtons(),
      )),
    );
  }

  List<Widget> getProductElements(BuildContext context);

  SizedBox getProductName(TextEditingController nameEditingController) {
    return SizedBox(
        width: 250,
        child: TextField(
          controller: nameEditingController,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: getInputDecoration("Name"),
          keyboardType: TextInputType.text,
          maxLines: 1,
          onChanged: (value) => product.name.value = value,
        ));
  }

  SizedBox getSpaceBetweenElements(
      {required bool isVertical, double multiplier = 2}) {
    if (isVertical) {
      return SizedBox(height: 25 * multiplier);
    }
    return SizedBox(width: 25 * multiplier);
  }

  InputDecoration getInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black87),
          borderRadius: BorderRadius.circular(10)),
    );
  }

  Obx getProductCategoryHandler() {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getProductCategory(),
            getSpaceBetweenElements(isVertical: false),
            getProductCategoryAddButton()
          ],
        ));
  }

  Obx getProductCategory() {
    List<DropdownMenuItem<int>> dropdownItems = getCategoryDropdownItems();
    RxInt? currentCategoryIndex = (getCurrentCategoryIndex()).obs;

    return Obx(() => DropdownButton<int>(
          hint: const Text("Select a category"),
          disabledHint: const Text("There are no categories"),
          value: currentCategoryIndex.value < 0
              ? null
              : currentCategoryIndex.value,
          items: dropdownItems,
          onChanged: dropdownItems.isEmpty
              ? null
              : (categoryIndex) => {
                    currentCategoryIndex.value = categoryIndex!,
                    product.category.value = productsCategoryController
                        .productCategories[currentCategoryIndex.value]
                  },
        ));
  }

  int getCurrentCategoryIndex() {
    if (index != null) {
      String currentCategory =
          myProductsController.products![index!].category.value;
      return productsCategoryController.productCategories
          .indexOf(currentCategory);
    }
    if (product.category.value.isNotEmpty) {
      return productsCategoryController.productCategories
          .indexOf(product.category.value);
    }
    return -1;
  }

  List<DropdownMenuItem<int>> getCategoryDropdownItems() {
    List<DropdownMenuItem<int>> dropdownItems = List.empty(growable: true);

    for (int index = 0;
        index < productsCategoryController.productCategories.length;
        index++) {
      dropdownItems.add(DropdownMenuItem<int>(
          value: index,
          child: Text(productsCategoryController.productCategories[index])));
    }

    return dropdownItems;
  }

  List<Widget> getProductButtons() {
    return <Widget>[
      const SizedBox(height: 16),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[getCancelButton(), getSubmitButton()])
    ];
  }

  OutlinedButton getCancelButton() {
    return OutlinedButton(
      onPressed: () {
        Get.back();
      },
      child: const Text('Cancel'),
    );
  }

  ElevatedButton getSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (index == null) {
          myProductsController.addProduct(product);
        } else {
          myProductsController.products![index!] = getUpdatedProduct();
        }

        Get.back();
      },
      child: index == null ? const Text('Add') : const Text('Update'),
    );
  }

  TextButton getProductCategoryAddButton() {
    return TextButton(
      onPressed: () {
        getProductCategoryDialog();
      },
      child: const Text('Add category'),
    );
  }

  Future<dynamic> getProductCategoryDialog() {
    final TextEditingController categoryTextController =
        TextEditingController();

    return Get.bottomSheet(Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          getProductCategoryDialogTitle(),
          getSpaceBetweenElements(isVertical: true),
          getCategoryInputField(categoryTextController),
          getSpaceBetweenElements(isVertical: true),
          getProductCategorySubmitButton(categoryTextController),
          getSpaceBetweenElements(isVertical: true),
          getProductCategoryCancelButton(),
        ],
      ),
    ));
  }

  Text getProductCategoryDialogTitle() {
    return const Text(
      'Add Category',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  TextField getCategoryInputField(
      TextEditingController categoryTextController) {
    return TextField(
      controller: categoryTextController,
      decoration: const InputDecoration(
        labelText: 'Category',
      ),
    );
  }

  OutlinedButton getProductCategoryCancelButton() {
    return OutlinedButton(
        child: const Text('Cancel'),
        onPressed: () {
          Get.back();
        });
  }

  ElevatedButton getProductCategorySubmitButton(
      TextEditingController categoryController) {
    return ElevatedButton(
      child: const Text('Add'),
      onPressed: () {
        String category = categoryController.text;
        if (category.isNotEmpty) {
          productsCategoryController.addProductCategory(category);
          Get.back();
        }
      },
    );
  }

  Widget getProductQuantity(TextEditingController quantityEditingController) {
    return SizedBox(
        width: 100,
        child: TextField(
          controller: quantityEditingController,
          decoration: getInputDecoration("Quantity"),
          keyboardType: TextInputType.number,
          maxLines: 1,
          onChanged: (value) => product.quantity.value = int.parse(value),
        ));
  }

  dynamic getUpdatedProduct();
}
