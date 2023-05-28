import 'package:get/get.dart';
import 'package:grocery_manager/models/product.dart';

class PantryItem extends Product {
  var isBought = false.obs;
  Rx<DateTime> expiryDate = DateTime(2023, 5, 16).obs;
  final DateTime defaultDate = DateTime(2023, 5, 16);
  var daysBeforeNotify = 1.obs;

  PantryItem({
    String name = "",
    String category = "",
    int quantity = 1,
    DateTime? expiryDate,
    int daysBeforeNotify = 1,
  }) : super(name: name, category: category, quantity: quantity) {
    if (expiryDate != null) {
      this.expiryDate.value = expiryDate;
    }
    this.daysBeforeNotify.value = daysBeforeNotify;
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    expiryDate.value = DateTime.parse(json['expiryDate']);
    daysBeforeNotify.value = json['daysBeforeNotify'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name.value,
      'category': category.value,
      'quantity': quantity.value,
      'expiryDate': expiryDate.value.toIso8601String(),
      'daysBeforeNotify': daysBeforeNotify.value,
    };
  }
}
