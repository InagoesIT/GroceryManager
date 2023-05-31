import 'package:get/get.dart';
import 'package:products_manager/models/product_model.dart';

class GroceryModel extends ProductModel {
  var isBought = false.obs;

  GroceryModel({
    String name = "",
    String category = "",
    bool isBought = false,
    int quantity = 1,
  }) : super(name: name, category: category, quantity: quantity) {
    this.isBought.value = isBought;
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    isBought.value = json['isBought'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name.value,
      'category': category.value,
      'isBought': isBought.value,
      'quantity': quantity.value
    };
  }

  @override
  void copyFrom(GroceryModel grocery) {
    name.value = grocery.name.value;
    category.value = grocery.category.value;
    isBought.value = grocery.isBought.value;
    quantity.value = grocery.quantity.value;
  }
}
