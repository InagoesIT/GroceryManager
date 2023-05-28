import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/product.dart';
import '../views/filters_page.dart';

class MyProductsController<T extends Product> extends GetxController {
  final RxList<T> _products = List<T>.empty(growable: true).obs;
  String key;
  RxString currentFilter = FiltersPage.NO_CATEGORY.obs;
  Function createProductFunction;

  MyProductsController(
      {required this.createProductFunction, required this.key});

  @override
  void onInit() {
    List? storedProducts = GetStorage().read<List>(key);

    if (storedProducts != null) {
      T product = createProductFunction();
      for (Map<String, dynamic> productMap in storedProducts) {
        product.fromJson(productMap);
        _products.add(product);
      }
    }
    ever(_products, (_) {
      GetStorage().write(key!, _products.toList());
    });
    super.onInit();
  }

  void addProduct(dynamic product) {
    _products.add(product);
  }

  dynamic getProduct(int index) {
    if (index > -1 && index < _products.length) {
      return _products[index];
    }
    return null;
  }

  int? getIndexOf(dynamic product) {
    return _products.indexOf(product);
  }

  int? getListSize() {
    return _products.length;
  }

  void setIndexWithProduct(int index, dynamic product) {
    if (index < 0 && index >= _products.length) {
      return;
    }
    _products[index] = product;
  }

  void removeProductWithIndex(int index) {
    if (index < 0 && index >= _products.length) {
      return;
    }
    _products.removeAt(index);
  }
}
