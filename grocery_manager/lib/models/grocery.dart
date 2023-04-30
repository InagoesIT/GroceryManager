import 'package:get/get.dart';

class Grocery extends GetxController {
  var title = "".obs;
  var category = "".obs;
  var isBought = false.obs;

  Grocery({
    required String title,
    required String category,
    bool isBought = false,
  }) {
    this.title.value = title;
    this.category.value = category;
    this.isBought.value = isBought;
  }

  factory Grocery.fromJson(Map<String, dynamic> json) {
    return Grocery(
        title: json['title'],
        category: json['category'],
        isBought: json['isBought']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title.value,
      'category': category.value,
      'isBought': isBought.value
    };
  }
}
