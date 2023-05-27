import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocery_manager/models/pantry_item.dart';
import '../models/grocery.dart';
import '../views/filters_page.dart';

abstract class MyProductsController extends GetxController {
  RxList<dynamic>? _products;
  String? key;
  RxString currentFilter = FiltersPage.NO_CATEGORY.obs;

  @override
  void onInit() {
    List? storedProducts = GetStorage().read<List>(key!);

    if (storedProducts != null) {
      if (key!.contains("pantry")) {
        // GetStorage().remove(key!);
        _products = storedProducts
            .map((grocery) => PantryItem.fromJson(grocery))
            .toList()
            .obs;
      } else {
        _products = storedProducts
            .map((grocery) => Grocery.fromJson(grocery))
            .toList()
            .obs;
      }
    }
    ever(_products!, (_) {
      GetStorage().write(key!, _products!.toList());
    });
    super.onInit();
  }

  void addProduct(dynamic product) {
    _products!.add(product);
  }

  dynamic getProduct(int index) {
    if (_products == null) {
      return null;
    }
    if (index > -1 && index < _products!.length) {
      return _products![index];
    }
    return null;
  }

  int? getIndexOf(dynamic product) {
    if (_products == null) {
      return null;
    }
    return _products!.indexOf(product);
  }

  int? getListSize() {
    if (_products == null) {
      return null;
    }
    return _products!.length;
  }

  void setIndexWithProduct(int index, dynamic product) {
    if (_products == null || (index < 0 && index >= _products!.length)) {
      return;
    }
    _products![index] = product;
  }

  void removeProductWithIndex(int index) {
    if (_products == null || (index < 0 && index >= _products!.length)) {
      return;
    }
    _products!.removeAt(index);
  }
}
