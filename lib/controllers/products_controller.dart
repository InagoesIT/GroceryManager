import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocery_manager/models/grocery_model.dart';
import '../models/pantry_item_model.dart';
import '../models/product_model.dart';
import '../views/filters_view.dart';

class ProductsController<T extends ProductModel> extends GetxController {
  final RxList<T> _allProducts = List<T>.empty(growable: true).obs;
  final RxList<T> _products = List<T>.empty(growable: true).obs;
  String key;
  RxString currentFilter = FiltersView.NO_CATEGORY.obs;
  Function createProductFunction;

  ProductsController({required this.createProductFunction, required this.key});

  @override
  void onInit() {
    List? storedProducts = GetStorage().read<List>(key);

    if (storedProducts != null) {
      for (var productMap in storedProducts) {
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
    if (currentFilter.value == FiltersView.NO_CATEGORY) {
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

  int getListSize() {
    return _products.length;
  }

  int getListSizeFromAll() {
    return _allProducts.length;
  }

  T? getProductFromAll(int index) {
    if (index > -1 && index < _allProducts.length) {
      return _allProducts[index];
    }
    return null;
  }

  void setIndexWithProduct(int index, T product) {
    if (index < 0 && index >= _products.length) {
      return;
    }
    _products[index] = product;
    int indexInAll = _allProducts.indexOf(product);
    _allProducts[indexInAll] = product;
  }

  void removeProductWithIndex(int index) {
    if (index < 0 && index >= _products.length) {
      return;
    }
    T product = _products[index];
    _allProducts.remove(product);
    filterProducts();
  }

  void transferToPantry() {
    final ProductsController<GroceryModel> groceryController =
        Get.find<ProductsController<GroceryModel>>();
    final ProductsController<PantryItemModel> pantryController =
        Get.find<ProductsController<PantryItemModel>>();
    var groceries = groceryController._allProducts;

    for (int index = 0; index < groceries.length; index++) {
      if (!groceries[index].isBought.value) {
        continue;
      }
      ProductModel product = groceries.removeAt(index);
      PantryItemModel pantryItem = PantryItemModel.fromProduct(product);
      pantryController.addProduct(pantryItem);
    }
  }
}
