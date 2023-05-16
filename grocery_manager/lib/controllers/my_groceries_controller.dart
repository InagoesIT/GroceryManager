import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/grocery.dart';

class MyGroceriesController extends GetxController {
  var groceries = <Grocery>[].obs;
  RxList groceryCategories = <String>[].obs;

  @override
  void onInit() {
    List? storedGroceries = GetStorage().read<List>('my_groceries');
    List? storedGroceryCategories =
        GetStorage().read<List>('grocery_categories');

    if (storedGroceries != null) {
      groceries = storedGroceries
          .map((grocery) => Grocery.fromJson(grocery))
          .toList()
          .obs;
    }
    if (storedGroceryCategories != null) {
      groceryCategories = storedGroceryCategories.toList().obs;
    }
    ever(groceries, (_) {
      GetStorage().write('my_groceries', groceries.toList());
      GetStorage().write('grocery_categories', groceryCategories.toList());
    });
    super.onInit();
  }

  void addGrocery(Grocery grocery) {
    groceries.add(grocery);
  }

  void addGroceryCategory(String category) {
    if (!groceryCategories.contains(category)) {
      groceryCategories.add(category);
    }
  }
}
