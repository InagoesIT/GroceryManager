import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/grocery.dart';
import '../controllers/my_groceries_controller.dart';

class MyGrocery extends StatelessWidget {
  final int? index;

  const MyGrocery({super.key, this.index});

  @override
  Widget build(BuildContext context) {
    final MyGroceriesController myGroceriesController = Get.find();
    String text = index == null
        ? " "
        : myGroceriesController.groceries[index!].title.value;
    TextEditingController textEditingController =
        TextEditingController(text: text);

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: index == null
                  ? const Text('Create a New Note ')
                  : const Text('Update note'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                height: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        autofocus: true,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Create a new note!!',
                          labelText: ' My Note',
                          border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black87),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        style: const TextStyle(fontSize: 20),
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (index == null) {
                                myGroceriesController.groceries.add(Grocery(
                                    title: textEditingController.text,
                                    category: "Ceva",
                                    isBought: false));
                              } else {
                                var updatenote =
                                    myGroceriesController.groceries[index!];
                                updatenote.title.value =
                                    textEditingController.text;
                                myGroceriesController.groceries[index!] =
                                    updatenote;
                              }

                              Get.back();
                            },
                            child: index == null
                                ? const Text('Add')
                                : const Text('Update'),
                          )
                        ])
                  ],
                ),
              ),
            )));
  }
}
