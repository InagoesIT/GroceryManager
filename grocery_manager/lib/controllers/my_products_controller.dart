import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocery_manager/models/pantry_item.dart';
import '../models/grocery.dart';

abstract class MyProductsController extends GetxController {
  RxList<dynamic>? products;
  String? key;

  @override
  void onInit() {
    List? storedProducts = GetStorage().read<List>(key!);

    if (storedProducts != null) {
      if (key!.contains("pantry")) {
        // GetStorage().remove(key!);
        products = storedProducts
            .map((grocery) => PantryItem.fromJson(grocery))
            .toList()
            .obs;
      } else {
        products = storedProducts
            .map((grocery) => Grocery.fromJson(grocery))
            .toList()
            .obs;
      }
    }
    ever(products!, (_) {
      GetStorage().write(key!, products!.toList());
    });
    super.onInit();
  }

  void addProduct(dynamic product) {
    products!.add(product);
  }
}
