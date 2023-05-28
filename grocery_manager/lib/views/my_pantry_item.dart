import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_manager/models/pantry_item.dart';
import 'package:grocery_manager/views/base_views/my_product.dart';

import '../controllers/my_products_controller.dart';

class MyPantryItem extends MyProduct<PantryItem> {
  @override
  final PantryItem product = PantryItem();
  @override
  final MyProductsController<PantryItem> myProductsController =
      Get.find<MyProductsController<PantryItem>>();

  MyPantryItem({super.key, super.index});

  @override
  PantryItem getUpdatedProduct() {
    PantryItem updatedGrocery = myProductsController.getProduct(super.index!)!;
    if (product.name.value != "") {
      updatedGrocery.name.value = product.name.value;
    }
    if (product.category.value != "") {
      updatedGrocery.category.value = product.category.value;
    }
    if (product.quantity.value != 1) {
      updatedGrocery.quantity.value = product.quantity.value;
    }
    if (product.expiryDate.value.compareTo(product.defaultDate) != 0) {
      updatedGrocery.expiryDate.value = product.expiryDate.value;
    }

    return updatedGrocery;
  }

  @override
  List<Widget> getProductElements(BuildContext context) {
    String name = "";
    if (index != null) {
      name = myProductsController.getProduct(super.index!)!.name.value;
    }
    TextEditingController nameEditingController =
        TextEditingController(text: name);

    return <Widget>[
      Column(children: <Widget>[
        getProductName(nameEditingController),
        getSpaceBetweenElements(isVertical: true),
        getProductCategoryHandler(),
        getSpaceBetweenElements(isVertical: true),
        getQuantityHandler(),
        getSpaceBetweenElements(isVertical: true),
        getPantryExpiryDate(context),
        getSpaceBetweenElements(isVertical: true),
        getDaysBeforeNotification()
      ])
    ];
  }

  Widget getQuantityHandler() {
    String quantity = "1";
    if (index != null) {
      quantity = myProductsController
          .getProduct(super.index!)!
          .quantity
          .value
          .toString();
    }
    TextEditingController quantityEditingController =
        TextEditingController(text: quantity);

    return getProductQuantity(quantityEditingController);
  }

  Obx getPantryExpiryDate(BuildContext context) {
    Rx<DateTime> date = Rx(product.defaultDate);
    if (index == null) {
      date.value = product.expiryDate.value;
    } else {
      date.value = myProductsController.getProduct(index!)!.expiryDate.value;
    }

    return Obx(() => Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(date.value.compareTo(product.defaultDate) == 0
                ? "No expiry date provided"
                : "${date.value.day}/${date.value.month}/${date.value.year}"),
            getSpaceBetweenElements(isVertical: false),
            TextButton(
                onPressed: () async {
                  DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100));
                  if (newDate != null) {
                    product.expiryDate.value = newDate;
                    date.value = newDate;
                  }
                },
                child: const Text("Select expiry date"))
          ],
        )));
  }

  Widget getDaysBeforeNotification() {
    String daysBeforeNotify = "1";
    if (index != null) {
      daysBeforeNotify = myProductsController
          .getProduct(super.index!)!
          .daysBeforeNotify
          .value
          .toString();
    }
    TextEditingController daysBeforeEditingController =
        TextEditingController(text: daysBeforeNotify);

    return SizedBox(
        width: 200,
        child: TextField(
          controller: daysBeforeEditingController,
          decoration: getInputDecoration("Days before expiry notification"),
          keyboardType: TextInputType.number,
          maxLines: 1,
          onChanged: (value) =>
              product.daysBeforeNotify.value = int.parse(value),
        ));
  }
}
