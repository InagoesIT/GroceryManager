import 'package:get/get.dart';

class PantryItem extends GetxController {
  var name = "".obs;
  var category = "".obs;
  var isBought = false.obs;
  var quantity = 1.obs;
  Rx<DateTime> expiryDate = DateTime(2023, 5, 16).obs;
  final DateTime defaultDate = DateTime(2023, 5, 16);
  var daysBeforeNotify = 1.obs;

  PantryItem(
      {String name = "",
      String category = "",
      bool isBought = false,
      int quantity = 1,
      DateTime? expiryDate,
      int daysBeforeNotify = 1}) {
    this.name.value = name;
    this.category.value = category;
    this.isBought.value = isBought;
    this.quantity.value = quantity;
    if (expiryDate != null) {
      this.expiryDate.value = expiryDate;
    }
    this.daysBeforeNotify.value = daysBeforeNotify;
  }

  factory PantryItem.fromJson(Map<String, dynamic> json) {
    return PantryItem(
      name: json['name'],
      category: json['category'],
      isBought: json['isBought'],
      quantity: json['quantity'],
      expiryDate: DateTime.parse(json['expiryDate']),
      daysBeforeNotify: json['daysBeforeNotify'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name.value,
      'category': category.value,
      'isBought': isBought.value,
      'quantity': quantity.value,
      'expiryDate': expiryDate.value.toIso8601String(),
      'daysBeforeNotify': daysBeforeNotify.value,
    };
  }
}
