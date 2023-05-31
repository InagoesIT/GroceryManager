import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:products_manager/models/product_model.dart';

class PantryItemModel extends ProductModel {
  var isBought = false.obs;
  Rx<DateTime> expiryDate = DateTime(2023, 5, 16).obs;
  static final DateTime defaultDate = DateTime(2023, 5, 16);
  static const TimeOfDay defaultTime = TimeOfDay(hour: 0, minute: 0);
  var daysBeforeNotify = 1.obs;
  Rx<TimeOfDay> expiryNotificationHour =
      const TimeOfDay(hour: 0, minute: 0).obs;

  PantryItemModel({
    String name = "",
    String category = "",
    int quantity = 1,
    DateTime? expiryDate,
    int daysBeforeNotify = 1,
    TimeOfDay? expiryNotificationHour,
  }) : super(name: name, category: category, quantity: quantity) {
    if (expiryDate != null) {
      this.expiryDate.value = expiryDate;
    }
    if (expiryNotificationHour != null) {
      this.expiryNotificationHour.value = expiryNotificationHour;
    }
    this.daysBeforeNotify.value = daysBeforeNotify;
  }

  PantryItemModel.fromProduct(ProductModel product)
      : super(
            name: product.name.value,
            category: product.category.value,
            quantity: product.quantity.value);

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    expiryDate.value = DateTime.parse(json['expiryDate']);
    expiryNotificationHour.value =
        parseTimeOfDay(json['expiryNotificationHour']);
    daysBeforeNotify.value = json['daysBeforeNotify'];
  }

  bool isNotificationTimeDifferentFromDefault(TimeOfDay anotherTime) {
    if (defaultTime.hour == anotherTime.hour &&
        defaultTime.minute == anotherTime.minute) {
      return false;
    }
    return true;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name.value,
      'category': category.value,
      'quantity': quantity.value,
      'expiryDate': expiryDate.value.toIso8601String(),
      'daysBeforeNotify': daysBeforeNotify.value,
      'expiryNotificationHour': formatTimeOfDay(expiryNotificationHour.value)
    };
  }

  @override
  void copyFrom(PantryItemModel grocery) {
    name.value = grocery.name.value;
    category.value = grocery.category.value;
    quantity.value = grocery.quantity.value;
    expiryDate.value = grocery.expiryDate.value;
    daysBeforeNotify.value = grocery.daysBeforeNotify.value;
    expiryNotificationHour.value = grocery.expiryNotificationHour.value;
  }

  TimeOfDay parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return TimeOfDay(hour: hour, minute: minute);
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour.toString();
    final minute = timeOfDay.minute.toString();

    return '$hour:$minute';
  }
}
