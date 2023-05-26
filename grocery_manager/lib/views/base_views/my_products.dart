import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_manager/views/my_groceries.dart';
import 'package:grocery_manager/views/my_pantry.dart';

import '../../controllers/navigation_controller.dart';

abstract class MyProducts extends StatelessWidget {
  final dynamic myProductsController = null;
  final String? pageTitle = null;
  final bool? isGrocery = null;
  final NavigationController? navigationController = null;

  const MyProducts({super.key});

  void getToNewMyProduct();

  void getToMyProduct(int index);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            bottomNavigationBar: getNavigationBar(),
            backgroundColor: Colors.white,
            appBar: AppBar(
                centerTitle: true,
                title: Text(pageTitle!),
                actions: [getMenu()]),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => getToNewMyProduct(),
            ),
            body: Padding(
                padding: const EdgeInsets.all(5), child: getMyProducts())));
  }

  List<PopupMenuEntry<int>> getMenuItems(context) {
    return [
      PopupMenuItem<int>(
          value: 1,
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text("opt 1"),
            subtitle: Text("opt 1 infos"),
          ))
    ];
  }

  PopupMenuButton getMenu() {
    return PopupMenuButton<int>(itemBuilder: getMenuItems);
  }

  Widget getNavigationBar() {
    return NavigationBar(
      onDestinationSelected: (int index) {
        navigationController?.changeCurrentPage(index);
        print("hi");
      },
      selectedIndex: navigationController?.currentPageIndex.value ?? 0,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.kitchen_rounded),
          label: 'My Pantry',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'My Groceries',
        )
      ],
    );
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
