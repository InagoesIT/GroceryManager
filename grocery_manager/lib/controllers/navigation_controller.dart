import 'package:get/get.dart';
import 'package:grocery_manager/views/my_groceries.dart';
import 'package:grocery_manager/views/my_pantry.dart';

class NavigationController extends GetxController {
  static const int PANTRY_PAGE_INDEX = 0;
  static const int GROCERY_PAGE_INDEX = 1;
  RxInt currentPageIndex = 0.obs;

  void changeCurrentPage(int pageIndex) {
    if (pageIndex == currentPageIndex.value) {
      return;
    }
    print(pageIndex);
    currentPageIndex.value = pageIndex;
    if (pageIndex == PANTRY_PAGE_INDEX) {
      Get.to(MyPantry());
      return;
    }
    Get.to(MyGroceries());
  }
}
