import 'package:get/get.dart';

class Grocery extends GetxController {
  var name = "".obs;
  var category = "".obs;
  var isBought = false.obs;
  var quantity = 1.obs;

  Grocery({
    String name = "",
    String category = "",
    bool isBought = false,
    int quantity = 1,
  }) {
    this.name.value = name;
    this.category.value = category;
    this.isBought.value = isBought;
    this.quantity.value = quantity;
  }

  factory Grocery.fromJson(Map<String, dynamic> json) {
    return Grocery(
        name: json['name'],
        category: json['category'],
        isBought: json['isBought'],
        quantity: json['quantity']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name.value,
      'category': category.value,
      'isBought': isBought.value,
      'quantity': quantity.value
    };
  }
}
