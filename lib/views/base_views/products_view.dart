import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:products_manager/models/pantry_item_model.dart';
import 'package:products_manager/models/product_model.dart';
import 'package:products_manager/views/filters_view.dart';

import '../../controllers/products_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../models/grocery_model.dart';

abstract class ProductsView<T extends ProductModel> extends StatelessWidget {
  final ProductsController<T>? productsController = null;
  final String? pageTitle = null;
  final bool? isGrocery = null;
  final NavigationController? navigationController = null;
  static const int FILTER_OPTION_INDEX = 0;

  const ProductsView({super.key});

  void getToNewProduct();

  void getToProduct(int index);

  List<PopupMenuEntry<int>> getMenuItems(context);

  void handleMenu(selectedIndex);

  Obx? getProductCheckbox(ProductsController<T> productsController, int index);

  Color getProductTileColor(T product);

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
              onPressed: () => getToNewProduct(),
            ),
            body: Padding(
                padding: const EdgeInsets.all(5),
                child: Obx(() => getProducts()))));
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
          label: 'Pantry',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Groceries',
        )
      ],
    );
  }

  Widget getProducts() {
    int? listSize = productsController!.getListSize();
    if (listSize == 0) {
      return getNoProductsText();
    }
    return ListView.builder(
        itemCount: listSize,
        itemBuilder: (context, index) =>
            getProduct(productsController!, index));
  }

  Widget getNoProductsText() {
    return const Center(
        child: Text(
      "There are currently no items here.",
      style: TextStyle(fontSize: 20),
    ));
  }

  GestureDetector getProduct(
      ProductsController<T> productsController, int index) {
    return GestureDetector(
      onTap: () => getToProduct(index),
      onDoubleTap: () => getProductDeleteDialog(productsController, index),
      child: Obx(() => getProductItem(productsController, index)),
    );
  }

  Future<dynamic> getProductDeleteDialog(
      ProductsController productsController, int index) {
    return Get.defaultDialog(
        title: "Delete item",
        middleText: productsController.getProduct(index)!.name.value,
        onCancel: () => {},
        buttonColor: Colors.redAccent,
        confirmTextColor: Colors.white,
        cancelTextColor: Colors.black,
        onConfirm: () {
          productsController.removeProductWithIndex(index);
          Get.back();
        });
  }

  Obx getProductItem(ProductsController<T> productsController, int index) {
    T product = productsController.getProduct(index)!;

    return Obx(() => Card(
            child: ListTile(
          title: getProductName(product),
          subtitle: getProductCategory(product),
          leading:
              isGrocery! ? getProductCheckbox(productsController, index) : null,
          trailing: getProductQuantity(product),
          tileColor: getProductTileColor(product),
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
      Get.to(FiltersView<GroceryModel>());
      return;
    }
    Get.to(FiltersView<PantryItemModel>());
  }
}
