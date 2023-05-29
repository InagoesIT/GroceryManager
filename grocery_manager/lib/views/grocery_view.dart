import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_manager/controllers/my_products_controller.dart';
import 'package:grocery_manager/views/base_views/product_view.dart';

import '../models/grocery_model.dart';

class GroceryView extends ProductView<GroceryModel> {
  @override
  final GroceryModel product = GroceryModel();
  @override
  final MyProductsController<GroceryModel> myProductsController =
      Get.find<MyProductsController<GroceryModel>>();

  GroceryView({super.key, super.index});

  @override
  GroceryModel getUpdatedProduct() {
    GroceryModel updatedGrocery =
        myProductsController.getProduct(super.index!)!;
    if (product.name.value != "") {
      updatedGrocery.name.value = product.name.value;
    }
    if (product.category.value != "") {
      updatedGrocery.category.value = product.category.value;
    }
    updatedGrocery.quantity.value = product.quantity.value;

    return updatedGrocery;
  }

  @override
  List<Widget> getProductElements(BuildContext context) {
    String name = "";
    if (index != null) {
      name = myProductsController.getProduct(super.index!)!.name.value;
    }
    String quantity = "1";
    if (index != null) {
      quantity = myProductsController
          .getProduct(super.index!)!
          .quantity
          .value
          .toString();
    }
    TextEditingController nameEditingController =
        TextEditingController(text: name);
    TextEditingController quantityEditingController =
        TextEditingController(text: quantity);

    return <Widget>[
      Column(children: <Widget>[
        getProductName(nameEditingController),
        getSpaceBetweenElements(isVertical: true),
        getProductCategoryHandler(),
        getSpaceBetweenElements(isVertical: true),
        getProductQuantity(quantityEditingController)
      ])
    ];
  }
}
