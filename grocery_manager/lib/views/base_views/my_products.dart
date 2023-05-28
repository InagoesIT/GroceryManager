import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_manager/models/pantry_item.dart';
import 'package:grocery_manager/models/product.dart';
import 'package:grocery_manager/views/filters_page.dart';

import '../../controllers/my_products_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../models/grocery.dart';

abstract class MyProducts<T extends Product> extends StatelessWidget {
  final MyProductsController<T>? myProductsController = null;
  final String? pageTitle = null;
  final bool? isGrocery = null;
  final NavigationController? navigationController = null;
  static const int FILTER_OPTION_INDEX = 0;

  const MyProducts({super.key});

  void getToNewMyProduct();

  void getToMyProduct(int index);

  List<PopupMenuEntry<int>> getMenuItems(context);

  void handleMenu(selectedIndex);

  Obx? getProductCheckbox(
      MyProductsController<T> myProductsController, int index);

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

  PopupMenuItem<int> getFilterMenuOption() {
    return const PopupMenuItem<int>(
        value: FILTER_OPTION_INDEX,
        child: ListTile(
          leading: Icon(Icons.filter_alt_outlined),
          title: Text("Filter"),
          subtitle: Text("Filter items by category"),
        ));
  }

  PopupMenuButton getMenu() {
    return PopupMenuButton<int>(
      itemBuilder: getMenuItems,
      onSelected: (selectedIndex) => handleMenu(selectedIndex),
    );
  }

  Widget getNavigationBar() {
    return NavigationBar(
      onDestinationSelected: (int index) {
        navigationController?.changeCurrentPage(index);
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
          itemCount: myProductsController!.getListSize(),
          itemBuilder: (context, index) =>
              getProduct(myProductsController!, index)),
    );
  }

  GestureDetector getProduct(
      MyProductsController<T> myProductsController, int index) {
    return GestureDetector(
      onTap: () => getToMyProduct(index),
      onDoubleTap: () => getProductDeleteDialog(myProductsController, index),
      child: Obx(() => getProductItem(myProductsController, index)),
    );
  }

  Future<dynamic> getProductDeleteDialog(
      MyProductsController myProductsController, int index) {
    return Get.defaultDialog(
        title: "Delete item",
        middleText: myProductsController.getProduct(index)!.name.value,
        onCancel: () => Get.back(),
        buttonColor: Colors.redAccent,
        confirmTextColor: Colors.white,
        cancelTextColor: Colors.black,
        onConfirm: () {
          myProductsController.removeProductWithIndex(index);
          Get.back();
        });
  }

  Obx getProductItem(MyProductsController<T> myProductsController, int index) {
    T product = myProductsController.getProduct(index)!;

    return Obx(() => Card(
            child: ListTile(
          title: getProductName(product),
          subtitle: getProductCategory(product),
          leading: isGrocery!
              ? getProductCheckbox(myProductsController, index)
              : null,
          trailing: getProductQuantity(product),
        )));
  }

  Text getProductName(T product) {
    return Text(product.name.value,
        style: isGrocery!
            ? TextStyle(decoration: getTextDecoration(product))
            : null);
  }

  Text getProductCategory(T product) {
    return Text(product.category.value,
        style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
            decoration: isGrocery! ? getTextDecoration(product) : null));
  }

  TextDecoration getTextDecoration(T product) {
    return TextDecoration.none;
  }

  Text getProductQuantity(dynamic product) {
    return Text(product.quantity.value.toString(),
        style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
            decoration: isGrocery! ? getTextDecoration(product) : null));
  }

  void redirectToFilterPage() {
    if (isGrocery!) {
      Get.to(FiltersPage<Grocery>());
      return;
    }
    Get.to(FiltersPage<PantryItem>());
  }
}
