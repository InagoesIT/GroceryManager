import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_manager/controllers/my_groceries_controller.dart';
import 'package:grocery_manager/views/base_views/my_product.dart';

import '../models/grocery.dart';

class MyGrocery extends MyProduct {
  @override
  final dynamic product = Grocery();
  @override
  final dynamic myProductsController = Get.find<MyGroceriesController>();

  MyGrocery({super.key, super.index});

  @override
  dynamic getUpdatedProduct() {
    Grocery updatedGrocery = myProductsController.products![super.index!];
    if (product.name.value != "") {
      updatedGrocery.name.value = product.name.value;
    }
    if (product.category.value != "") {
      updatedGrocery.category.value = product.category.value;
    }
    if (product.quantity.value != 1) {
      updatedGrocery.quantity.value = product.quantity.value;
    }

    return updatedGrocery;
  }

  @override
  List<Widget> getProductElements(BuildContext context) {
    String name = "";
    if (index != null) {
      name = myProductsController.products![super.index!].name.value;
    }
    String quantity = "1";
    if (index != null) {
      quantity = myProductsController.products![super.index!].quantity.value
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
