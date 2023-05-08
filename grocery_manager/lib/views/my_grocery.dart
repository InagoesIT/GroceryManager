import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/grocery.dart';
import '../controllers/my_groceries_controller.dart';

class MyGrocery extends StatelessWidget {
  final int? index;

  const MyGrocery({super.key, this.index});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: index == null
                  ? const Text('Add a new grocery')
                  : const Text('Update grocery'),
            ),
            body: getBody()));
  }

  Widget getBody() {
    final MyGroceriesController myGroceriesController = Get.find();
    String name = " ";
    if (index != null) {
      name = myGroceriesController.groceries[index!].title.value;
    }
    TextEditingController nameEditingController =
        TextEditingController(text: name);

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: getGroceryElements(nameEditingController) +
            getGroceryButtons(nameEditingController),
      ),
    );
  }

  List<Widget> getGroceryElements(TextEditingController nameEditingController) {
    return <Widget>[
      Obx(() => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            getGroceryName(nameEditingController),
            const SizedBox(width: 16),
            getGroceryCategory(),
            getGroceryCategoryAddButton()
          ]))
    ];
  }

  SizedBox getGroceryName(TextEditingController nameEditingController) {
    return SizedBox(
        width: 250,
        child: TextField(
          controller: nameEditingController,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Grocery name',
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black87),
                borderRadius: BorderRadius.circular(10)),
          ),
          keyboardType: TextInputType.text,
          maxLines: 1,
        ));
  }

  Obx getGroceryCategory() {
    final MyGroceriesController myGroceriesController = Get.find();
    List<DropdownMenuItem<int>> dropdownItems = List.empty(growable: true);
    RxInt? currentCategoryIndex = (-1).obs;

    if (index != null) {
      String currentCategory =
          myGroceriesController.groceries[index!].category.value;
      currentCategoryIndex.value = myGroceriesController.groceryCategories
          .toList()
          .indexOf(currentCategory);
    }
    for (int index = 0;
        index < myGroceriesController.groceryCategories.toList().length;
        index++) {
      dropdownItems.add(DropdownMenuItem<int>(
          value: index,
          child:
              Text(myGroceriesController.groceryCategories.toList()[index])));
    }

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
                    if (index != null)
                      {
                        myGroceriesController.groceries[index!].category.value =
                            myGroceriesController.groceryCategories
                                .toList()[categoryIndex],
                      }
                  },
        ));
  }

  ElevatedButton getGroceryCategoryAddButton() {
    return ElevatedButton(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add Category',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: categoryController,
            decoration: const InputDecoration(
              labelText: 'Category',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text('Add'),
            onPressed: () {
              String category = categoryController.text;
              if (category.isNotEmpty) {
                myGroceriesController.addGroceryCategory(category);
                Get.back();
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Get.back();
              }),
        ],
      ),
    ));
  }

  List<Widget> getGroceryButtons(TextEditingController nameEditingController) {
    return <Widget>[
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        getCancelButton(),
        getSubmitButton(nameEditingController)
      ])
    ];
  }

  ElevatedButton getCancelButton() {
    return ElevatedButton(
      onPressed: () {
        Get.back();
      },
      child: const Text('Cancel'),
    );
  }

  ElevatedButton getSubmitButton(TextEditingController nameEditingController) {
    MyGroceriesController myGroceriesController = Get.find();

    return ElevatedButton(
      onPressed: () {
        if (index == null) {
          myGroceriesController.groceries.add(Grocery(
              title: nameEditingController.text,
              category: "Ceva",
              isBought: false));
        } else {
          Grocery updatedGrocery = myGroceriesController.groceries[index!];
          updatedGrocery.title.value = nameEditingController.text;
          myGroceriesController.groceries[index!] = updatedGrocery;
        }

        Get.back();
      },
      child: index == null ? const Text('Add') : const Text('Update'),
    );
  }
}
