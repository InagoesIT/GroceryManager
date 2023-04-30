import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/grocery.dart';

class MyGroceriesController extends GetxController {
  var groceries = <Grocery>[].obs;

  @override
  void onInit() {
    List? storedGroceries = GetStorage().read<List>('groceries');

    if (storedGroceries != null) {
      groceries = storedGroceries
          .map((grocery) => Grocery.fromJson(grocery))
          .toList()
          .obs;
    }
    ever(groceries, (_) {
      GetStorage().write('groceries', groceries.toList());
    });
    super.onInit();
  }

  void add(Grocery grocery) {
    groceries.add(grocery);
  }
}
