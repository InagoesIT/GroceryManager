import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProductsCategoryController extends GetxController {
  RxList productCategories = <String>[].obs;

  @override
  void onInit() {
    List? storedProductCategories =
        GetStorage().read<List>('product_categories');

    if (storedProductCategories != null) {
      productCategories = storedProductCategories.toList().obs;
    }
    ever(productCategories, (_) {
      GetStorage().write('product_categories', productCategories.toList());
    });
    super.onInit();
  }

  void addProductCategory(String category) {
    if (!productCategories.contains(category)) {
      productCategories.add(category);
    }
  }
}
