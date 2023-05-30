import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_manager/models/pantry_item_model.dart';
import 'package:grocery_manager/views/base_views/product_view.dart';

import '../controllers/my_products_controller.dart';
import '../services/notifications_service.dart';

class PantryItemView extends ProductView<PantryItemModel> {
  @override
  final PantryItemModel product = PantryItemModel();
  @override
  final MyProductsController<PantryItemModel> myProductsController =
      Get.find<MyProductsController<PantryItemModel>>();
  final NotificationsService notificationsService =
      Get.find<NotificationsService>();

  PantryItemView({super.key, super.index});

  @override
  PantryItemModel getUpdatedProduct() {
    PantryItemModel updatedGrocery =
        myProductsController.getProduct(super.index!)!;
    if (product.name.value != "") {
      updatedGrocery.name.value = product.name.value;
    }
    if (product.category.value != "") {
      updatedGrocery.category.value = product.category.value;
    }
    if (product.expiryDate.value.compareTo(PantryItemModel.defaultDate) != 0) {
      updatedGrocery.expiryDate.value = product.expiryDate.value;
    }
    updatedGrocery.quantity.value = product.quantity.value;
    updatedGrocery.daysBeforeNotify.value = product.daysBeforeNotify.value;
    handleNotificationFor(updatedGrocery);

    return updatedGrocery;
  }

  void handleNotificationFor(PantryItemModel pantryItem) {
    if (index == null) {
      notificationsService.scheduleNotificationForItem(pantryItem);
      return;
    }
    notificationsService.cancelNotificationFor(pantryItem);
    notificationsService.scheduleNotificationForItem(pantryItem);
  }

  bool isNotificationDataChanged(
      PantryItemModel newPantryItem, PantryItemModel oldPantryItem) {
    if (newPantryItem.expiryDate.value
                .compareTo(oldPantryItem.expiryDate.value) ==
            0 &&
        newPantryItem.daysBeforeNotify.value ==
            oldPantryItem.daysBeforeNotify.value) {
      return false;
    }
    return true;
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
    Rx<DateTime> date = Rx(PantryItemModel.defaultDate);
    if (index == null) {
      date.value = product.expiryDate.value;
    } else {
      date.value = myProductsController.getProduct(index!)!.expiryDate.value;
    }

    return Obx(() => Center(
            child: Row(
          children: [
            Text(date.value.compareTo(PantryItemModel.defaultDate) == 0
                ? "No expiry date provided"
                : "${date.value.day}/${date.value.month}/${date.value.year} ${date.value.hour}:${date.value.minute}:00"),
            getSpaceBetweenElements(isVertical: false),
            TextButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100));
                  if (pickedDate == null) {
                    return;
                  }
                  date.value = pickedDate;
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (time == null) {
                    product.expiryDate.value = DateTime(
                      date.value.year,
                      date.value.month,
                      date.value.day,
                    );
                    return;
                  }
                  date.value = DateTime(
                    time.hour,
                    time.minute,
                  );
                  product.expiryDate.value = DateTime(
                    date.value.year,
                    date.value.month,
                    date.value.day,
                    date.value.hour,
                    date.value.minute,
                  );
                },
                child: const Text("Select expiry date"))
          ],
        )));
  }

  Align getDaysBeforeNotification() {
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
    int? processedValue;

    return Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
            width: 200,
            child: TextField(
                controller: daysBeforeEditingController,
                decoration:
                    getInputDecoration("Days before expiry notification"),
                keyboardType: TextInputType.number,
                maxLines: 1,
                onChanged: (value) => {
                      processedValue = getValue(value),
                      if (processedValue != null)
                        product.daysBeforeNotify.value = int.parse(value)
                    })));
  }
}
