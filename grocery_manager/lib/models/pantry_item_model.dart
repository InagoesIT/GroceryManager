import 'package:get/get.dart';
import 'package:grocery_manager/models/product_model.dart';

class PantryItemModel extends ProductModel {
  var isBought = false.obs;
  Rx<DateTime> expiryDate = DateTime(2023, 5, 16).obs;
  final DateTime defaultDate = DateTime(2023, 5, 16);
  var daysBeforeNotify = 1.obs;

  PantryItemModel({
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

  PantryItemModel.fromProduct(ProductModel product)
      : super(
            name: product.name.value,
            category: product.category.value,
            quantity: product.quantity.value);

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

  @override
  void copyFrom(PantryItemModel grocery) {
    name.value = grocery.name.value;
    category.value = grocery.category.value;
    quantity.value = grocery.quantity.value;
    expiryDate.value = grocery.expiryDate.value;
    daysBeforeNotify.value = grocery.daysBeforeNotify.value;
  }
}
