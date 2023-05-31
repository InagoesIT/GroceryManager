import 'package:get/get.dart';
import 'package:grocery_manager/views/groceries_view.dart';
import 'package:grocery_manager/views/pantry_view.dart';

class NavigationController extends GetxController {
  static const int PANTRY_PAGE_INDEX = 0;
  static const int GROCERY_PAGE_INDEX = 1;
  RxInt currentPageIndex = 0.obs;

  void changeCurrentPage(int pageIndex) {
    if (pageIndex == currentPageIndex.value) {
      return;
    }
    currentPageIndex.value = pageIndex;
    if (pageIndex == PANTRY_PAGE_INDEX) {
      Get.to(PantryView());
      return;
    }
    Get.to(GroceriesView());
  }
}
