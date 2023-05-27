import 'package:get/get.dart';
import 'package:grocery_manager/controllers/my_products_controller.dart';
import '../models/pantry_item.dart';

class MyPantryController extends MyProductsController {
  @override
  RxList<dynamic>? _products = <PantryItem>[].obs;
  @override
  String? key = "my_pantry";
}
