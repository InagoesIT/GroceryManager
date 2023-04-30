import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_groceries_controller.dart';
import '../models/grocery.dart';
import 'my_grocery.dart';

class MyGroceries extends StatelessWidget {
  const MyGroceries({super.key});

  @override
  Widget build(BuildContext context) {
    MyGroceriesController myGroceriesController =
        Get.put(MyGroceriesController());

    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: const Text('My Groceries'),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => Get.to(const MyGrocery()),
            ),
            body: Padding(
                padding: const EdgeInsets.all(5),
                child: getMyGroceries(myGroceriesController))));
  }

  Widget getMyGroceries(MyGroceriesController myGroceriesController) {
    List<Grocery> groceries = myGroceriesController.groceries;

    return Obx(
      () => ListView.builder(
          itemCount: myGroceriesController.groceries.length,
          itemBuilder: (context, index) => getGrocery(groceries, index)),
    );
  }

  GestureDetector getGrocery(List<Grocery> groceries, int index) {
    return GestureDetector(
      onTap: () => Get.to(MyGrocery(index: index)),
      onLongPress: () => getGroceryDeleteDialog(groceries, index),
      child: Obx(() => getGroceryCard(groceries, index)),
    );
  }

  Future<dynamic> getGroceryDeleteDialog(List<Grocery> groceries, int index) {
    return Get.defaultDialog(
        title: 'Delete Grocery',
        middleText: groceries[index].title.value,
        onCancel: () => Get.back(),
        buttonColor: Colors.redAccent,
        confirmTextColor: Colors.white,
        cancelTextColor: Colors.black,
        onConfirm: () {
          groceries.removeAt(index);
          Get.back();
        });
  }

  Obx getGroceryCard(List<Grocery> groceries, int index) {
    var grocery = groceries[index];

    return Obx(() => Card(
            child: ListTile(
          title: getGroceryName(grocery),
          subtitle: getGroceryCategory(grocery),
          leading: getGroceryCheckbox(groceries, index),
        )));
  }

  Text getGroceryName(Grocery grocery) {
    return Text(grocery.title.value,
        style: TextStyle(decoration: getTextDecoration(grocery)));
  }

  Text getGroceryCategory(Grocery grocery) {
    return Text(grocery.category.value,
        style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
            decoration: getTextDecoration(grocery)));
  }

  TextDecoration getTextDecoration(Grocery grocery) {
    return grocery.isBought.value
        ? TextDecoration.lineThrough
        : TextDecoration.none;
  }

  Obx getGroceryCheckbox(List<Grocery> groceries, int index) {
    var grocery = groceries[index];

    return Obx(() => Checkbox(
          value: grocery.isBought.value,
          onChanged: (isEnabled) {
            grocery.isBought.value = grocery.isBought.value ? false : true;
            if (grocery.isBought.value) {
              groceries.removeAt(index);
              groceries.add(grocery);
            }
          },
        ));
  }
}
