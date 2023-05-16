import 'package:get/get.dart';
import 'package:grocery_manager/views/base_views/my_products.dart';
import '../controllers/my_groceries_controller.dart';
import '../controllers/product_categories_controller.dart';
import 'my_grocery.dart';

class MyGroceries extends MyProducts {
  @override
  final dynamic myProductsController = Get.put(MyGroceriesController());
  @override
  final String? pageTitle = "My Groceries";
  @override
  final bool? isGrocery = true;
  final dynamic productCategoriesController =
      Get.find<ProductsCategoryController>();

  MyGroceries({super.key});

  @override
  void getToMyProduct(int index) {
    Get.to(MyGrocery(index: index));
  }

  @override
  void getToNewMyProduct() {
    Get.to(MyGrocery());
  }
}
