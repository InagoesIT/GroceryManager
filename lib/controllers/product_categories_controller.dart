import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProductsCategoryController extends GetxController {
  RxList _productCategories = <String>[].obs;

  @override
  void onInit() {
    List? storedProductCategories =
        GetStorage().read<List>('product_categories');

    if (storedProductCategories != null) {
      _productCategories = storedProductCategories.toList().obs;
    }
    ever(_productCategories, (_) {
      GetStorage().write('product_categories', _productCategories.toList());
    });
    super.onInit();
  }

  void addProductCategory(String category) {
    if (!_productCategories.contains(category)) {
      _productCategories.add(category);
    }
  }

  String? getCategory(int index) {
    if (index > -1 && index < _productCategories.length) {
      return _productCategories[index];
    }
    return null;
  }

  int getIndexOf(String category) {
    return _productCategories.indexOf(category);
  }

  int getListSize() {
    return _productCategories.length;
  }
}
