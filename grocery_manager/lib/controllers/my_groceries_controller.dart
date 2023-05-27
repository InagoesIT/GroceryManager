import 'package:get/get.dart';
import 'package:grocery_manager/controllers/my_products_controller.dart';
import '../models/grocery.dart';

class MyGroceriesController extends MyProductsController {
  @override
  RxList<dynamic>? _products = <Grocery>[].obs;
  @override
  String? key = "my_groceries";
}
