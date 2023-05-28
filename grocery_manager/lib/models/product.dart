import 'package:get/get.dart';

class Product extends GetxController {
  var name = "".obs;
  var category = "".obs;
  var quantity = 1.obs;

  Product({
    String name = "",
    String category = "",
    int quantity = 1,
  }) {
    this.name.value = name;
    this.category.value = category;
    this.quantity.value = quantity;
  }

  void fromJson(Map<String, dynamic> json) {
    name.value = json['name'];
    category.value = json['category'];
    quantity.value = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name.value,
      'category': category.value,
      'quantity': quantity.value,
    };
  }
}
