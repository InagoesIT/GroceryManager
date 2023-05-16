import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_manager/views/my_groceries.dart';
import 'package:grocery_manager/views/my_pantry.dart';

abstract class MyProducts extends StatelessWidget {
  final dynamic myProductsController = null;
  final String? pageTitle = null;
  final bool? isGrocery = null;

  const MyProducts({super.key});

  void getToNewMyProduct();

  void getToMyProduct(int index);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: Text(pageTitle!),
              actions: [
                IconButton(
                    onPressed: () =>
                        isGrocery! ? Get.to(MyPantry()) : Get.to(MyGroceries()),
                    icon: isGrocery!
                        ? const Icon(Icons.kitchen_rounded)
                        : const Icon(Icons.shopping_cart_outlined))
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => getToNewMyProduct(),
            ),
            body: Padding(
                padding: const EdgeInsets.all(5), child: getMyProducts())));
  }

  Widget getMyProducts() {
    return Obx(
      () => ListView.builder(
          itemCount: myProductsController.products!.length,
          itemBuilder: (context, index) =>
              getProduct(myProductsController.products!, index)),
    );
  }

  GestureDetector getProduct(List<dynamic> products, int index) {
    return GestureDetector(
      onTap: () => getToMyProduct(index),
      onDoubleTap: () => getProductDeleteDialog(products, index),
      child: Obx(() => getProductItem(products, index)),
    );
  }

  Future<dynamic> getProductDeleteDialog(List<dynamic> products, int index) {
    return Get.defaultDialog(
        title: "Delete item",
        middleText: products[index].name.value,
        onCancel: () => Get.back(),
        buttonColor: Colors.redAccent,
        confirmTextColor: Colors.white,
        cancelTextColor: Colors.black,
        onConfirm: () {
          myProductsController.products.removeAt(index);
          Get.back();
        });
  }

  Obx getProductItem(List<dynamic> products, int index) {
    var product = products[index];

    return Obx(() => Card(
            child: ListTile(
          title: getProductName(product),
          subtitle: getProductCategory(product),
          leading: isGrocery! ? getProductCheckbox(products, index) : null,
          trailing: getProductQuantity(product),
        )));
  }

  Text getProductName(dynamic product) {
    return Text(product.name.value,
        style: isGrocery!
            ? TextStyle(decoration: getTextDecoration(product))
            : null);
  }

  Text getProductCategory(dynamic product) {
    return Text(product.category.value,
        style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
            decoration: isGrocery! ? getTextDecoration(product) : null));
  }

  TextDecoration getTextDecoration(dynamic product) {
    return product.isBought.value
        ? TextDecoration.lineThrough
        : TextDecoration.none;
  }

  Obx getProductCheckbox(List<dynamic> products, int index) {
    var product = myProductsController.products[index];

    return Obx(() => Checkbox(
          value: product.isBought.value,
          onChanged: (isEnabled) {
            product.isBought.value = !product.isBought.value;
            if (product.isBought.value) {
              myProductsController.products.removeAt(index);
              myProductsController.products.add(product);
            }
          },
        ));
  }

  Text getProductQuantity(dynamic product) {
    return Text(product.quantity.value.toString(),
        style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
            decoration: isGrocery! ? getTextDecoration(product) : null));
  }
}
