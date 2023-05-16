import 'package:get/get.dart';
import 'package:grocery_manager/controllers/my_pantry_controller.dart';
import 'package:grocery_manager/views/base_views/my_products.dart';
import 'package:grocery_manager/views/my_pantry_item.dart';
import '../controllers/product_categories_controller.dart';

class MyPantry extends MyProducts {
  @override
  final dynamic myProductsController = Get.put(MyPantryController());
  @override
  final String? pageTitle = "My Pantry";
  @override
  final bool? isGrocery = false;
  final dynamic productCategoriesController =
      Get.put(ProductsCategoryController());

  MyPantry({super.key});

  @override
  void getToMyProduct(int index) {
    Get.to(MyPantryItem(index: index));
  }

  @override
  void getToNewMyProduct() {
    Get.to(MyPantryItem());
  }
}
