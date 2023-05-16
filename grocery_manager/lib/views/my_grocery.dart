import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/grocery.dart';
import '../controllers/my_groceries_controller.dart';

class MyGrocery extends StatelessWidget {
  final int? index;
  final Grocery grocery = Grocery();

  MyGrocery({super.key, this.index});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: index == null
                  ? const Text('Add a new grocery')
                  : const Text('Update grocery'),
            ),
            body: getBody(context)));
  }

  Widget getBody(BuildContext context) {
    final MyGroceriesController myGroceriesController = Get.find();
    String name = "";
    if (index != null) {
      name = myGroceriesController.groceries[index!].name.value;
    }
    String quantity = "1";
    if (index != null) {
      quantity =
          myGroceriesController.groceries[index!].quantity.value.toString();
    }
    TextEditingController nameEditingController =
        TextEditingController(text: name);
    TextEditingController quantityEditingController =
        TextEditingController(text: quantity);

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: getGroceryElements(
                nameEditingController, quantityEditingController) +
            getGroceryButtons(),
      ),
    );
  }

  List<Widget> getGroceryElements(TextEditingController nameEditingController,
      TextEditingController quantityEditingController) {
    return <Widget>[
      Column(children: <Widget>[
        getGroceryName(nameEditingController),
        getSpaceBetweenElements(isVertical: true),
        getGroceryCategoryHandler(),
        getSpaceBetweenElements(isVertical: true),
        getGroceryQuantity(quantityEditingController)
      ])
    ];
  }

  SizedBox getGroceryName(TextEditingController nameEditingController) {
    return SizedBox(
        width: 250,
        child: TextField(
          controller: nameEditingController,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: getInputDecoration("Name"),
          keyboardType: TextInputType.text,
          maxLines: 1,
          onChanged: (value) => grocery.name.value = value,
        ));
  }

  SizedBox getSpaceBetweenElements(
      {required bool isVertical, double multiplier = 1}) {
    if (isVertical) {
      return SizedBox(height: 25 * multiplier);
    }
    return SizedBox(width: 25 * multiplier);
  }

  InputDecoration getInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black87),
          borderRadius: BorderRadius.circular(10)),
    );
  }

  Obx getGroceryCategoryHandler() {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getGroceryCategory(),
            getSpaceBetweenElements(isVertical: false),
            getGroceryCategoryAddButton()
          ],
        ));
  }

  Obx getGroceryCategory() {
    List<DropdownMenuItem<int>> dropdownItems = getCategoryDropdownItems();
    final MyGroceriesController myGroceriesController = Get.find();
    RxInt? currentCategoryIndex = (getCurrentCategoryIndex()).obs;

    return Obx(() => DropdownButton<int>(
          hint: const Text("Select a category"),
          disabledHint: const Text("There are no categories"),
          value: currentCategoryIndex.value < 0
              ? null
              : currentCategoryIndex.value,
          items: dropdownItems,
          onChanged: dropdownItems.isEmpty
              ? null
              : (categoryIndex) => {
                    currentCategoryIndex.value = categoryIndex!,
                    grocery.category.value = myGroceriesController
                        .groceryCategories[currentCategoryIndex.value]
                  },
        ));
  }

  int getCurrentCategoryIndex() {
    final MyGroceriesController myGroceriesController = Get.find();

    if (index != null) {
      String currentCategory =
          myGroceriesController.groceries[index!].category.value;
      return myGroceriesController.groceryCategories.indexOf(currentCategory);
    }
    if (grocery.category.value.isNotEmpty) {
      return myGroceriesController.groceryCategories
          .indexOf(grocery.category.value);
    }
    return -1;
  }

  List<DropdownMenuItem<int>> getCategoryDropdownItems() {
    final MyGroceriesController myGroceriesController = Get.find();
    List<DropdownMenuItem<int>> dropdownItems = List.empty(growable: true);

    for (int index = 0;
        index < myGroceriesController.groceryCategories.length;
        index++) {
      dropdownItems.add(DropdownMenuItem<int>(
          value: index,
          child: Text(myGroceriesController.groceryCategories[index])));
    }

    return dropdownItems;
  }

  TextButton getGroceryCategoryAddButton() {
    return TextButton(
      onPressed: () {
        getGroceryCategoryDialog();
      },
      child: const Text('Add category'),
    );
  }

  Future<dynamic> getGroceryCategoryDialog() {
    final MyGroceriesController myGroceriesController = Get.find();
    final TextEditingController categoryController = TextEditingController();

    return Get.bottomSheet(Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          getGroceryCategoryDialogTitle(),
          getSpaceBetweenElements(isVertical: true),
          getCategoryInputField(categoryController),
          getSpaceBetweenElements(isVertical: true),
          getGroceryCategorySubmitButton(
              myGroceriesController, categoryController),
          getSpaceBetweenElements(isVertical: true),
          getGroceryCategoryCancelButton(),
        ],
      ),
    ));
  }

  Text getGroceryCategoryDialogTitle() {
    return const Text(
      'Add Category',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  TextField getCategoryInputField(TextEditingController categoryController) {
    return TextField(
      controller: categoryController,
      decoration: const InputDecoration(
        labelText: 'Category',
      ),
    );
  }

  OutlinedButton getGroceryCategoryCancelButton() {
    return OutlinedButton(
        child: const Text('Cancel'),
        onPressed: () {
          Get.back();
        });
  }

  ElevatedButton getGroceryCategorySubmitButton(
      MyGroceriesController myGroceriesController,
      TextEditingController categoryController) {
    return ElevatedButton(
      child: const Text('Add'),
      onPressed: () {
        String category = categoryController.text;
        if (category.isNotEmpty) {
          myGroceriesController.addGroceryCategory(category);
          Get.back();
        }
      },
    );
  }

  Widget getGroceryQuantity(TextEditingController quantityEditingController) {
    return SizedBox(
        width: 100,
        child: TextField(
          controller: quantityEditingController,
          decoration: getInputDecoration("Quantity"),
          keyboardType: TextInputType.number,
          maxLines: 1,
          onChanged: (value) => grocery.quantity.value = int.parse(value),
        ));
  }

  List<Widget> getGroceryButtons() {
    return <Widget>[
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        getCancelButton(),
        getSubmitButton()
      ])
    ];
  }

  OutlinedButton getCancelButton() {
    return OutlinedButton(
      onPressed: () {
        Get.back();
      },
      child: const Text('Cancel'),
    );
  }

  ElevatedButton getSubmitButton() {
    MyGroceriesController myGroceriesController = Get.find();

    return ElevatedButton(
      onPressed: () {
        if (index == null) {
          myGroceriesController.groceries.add(grocery);
        } else {
          Grocery updatedGrocery = myGroceriesController.groceries[index!];
          if (grocery.name.value != "") {
            updatedGrocery.name.value = grocery.name.value;
          }
          if (grocery.category.value != "") {
            updatedGrocery.category.value = grocery.category.value;
          }
          if (grocery.quantity.value != 1) {
            updatedGrocery.quantity.value = grocery.quantity.value;
          }
          myGroceriesController.groceries[index!] = updatedGrocery;
        }

        Get.back();
      },
      child: index == null ? const Text('Add') : const Text('Update'),
    );
  }
}
