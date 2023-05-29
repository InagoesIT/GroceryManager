import 'package:get/get.dart';

class ProductModel extends GetxController {
  var name = "".obs;
  var category = "".obs;
  var quantity = 1.obs;

  ProductModel({
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

  void copyFrom(covariant ProductModel grocery) {
    name.value = grocery.name.value;
    category.value = grocery.category.value;
    quantity.value = grocery.quantity.value;
  }
}
