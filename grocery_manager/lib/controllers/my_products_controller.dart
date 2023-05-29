import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/product.dart';
import '../views/filters_page.dart';

class MyProductsController<T extends Product> extends GetxController {
  final RxList<T> _allProducts = List<T>.empty(growable: true).obs;
  RxList<T> _products = List<T>.empty(growable: true).obs;
  String key;
  RxString currentFilter = FiltersPage.NO_CATEGORY.obs;
  Function createProductFunction;

  MyProductsController(
      {required this.createProductFunction, required this.key});

  @override
  void onInit() {
    List? storedProducts = GetStorage().read<List>(key);

    if (storedProducts != null) {
      for (Map<String, dynamic> productMap in storedProducts) {
        T product = createProductFunction();
        product.fromJson(productMap);
        _allProducts.add(product);
      }
      _products.value = _allProducts;
    }
    ever(_allProducts, (_) {
      GetStorage().write(key, _allProducts.toList());
    });
    super.onInit();
  }

  void filterProducts() {
    if (currentFilter.value == FiltersPage.NO_CATEGORY) {
      _products.value = _allProducts;
      return;
    }
    _products.value = _allProducts
        .where((product) => product.category.value == currentFilter.value)
        .toList();
  }

  void addProduct(T product) {
    _allProducts.add(product);
    filterProducts();
  }

  T? getProduct(int index) {
    if (index > -1 && index < _products.length) {
      return _products[index];
    }
    return null;
  }

  int? getIndexOf(T product) {
    return _products.indexOf(product);
  }

  int? getListSize() {
    return _products.length;
  }

  void setIndexWithProduct(int index, T product) {
    if (index < 0 && index >= _products.length) {
      return;
    }
    _products[index] = product;
  }

  void removeProductWithIndex(int index) {
    if (index < 0 && index >= _products.length) {
      return;
    }
    T product = _products[index];
    _allProducts.remove(product);
    filterProducts();
  }
}
