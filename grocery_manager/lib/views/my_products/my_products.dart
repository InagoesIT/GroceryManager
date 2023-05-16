// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../controllers/my_products_controller.dart';
// import '../../models/grocery.dart';

// abstract class MyProducts extends StatelessWidget {
//   final MyProductsController? myGroceriesController = null;
//   final String? pageTitle = null;
//   final List<dynamic>? products = null;

//   const MyProducts({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//             backgroundColor: Colors.white,
//             appBar: AppBar(
//               centerTitle: true,
//               title: Text(pageTitle!),
//             ),
//             floatingActionButton: FloatingActionButton(
//               child: const Icon(Icons.add),
//               onPressed: () => getToNewMyProduct(),
//             ),
//             body: Padding(
//                 padding: const EdgeInsets.all(5), child: getMyProducts())));
//   }

//   void getToNewMyProduct();

//   Widget getMyProducts() {
//     return Obx(
//       () => ListView.builder(
//           itemCount: products!.length,
//           itemBuilder: (context, index) => getProduct(products!, index)),
//     );
//   }

//   GestureDetector getProduct(List<dynamic> products, int index) {
//     return GestureDetector(
//       onTap: () => getToMyProduct(index),
//       onDoubleTap: () => getProductDeleteDialog(products, index),
//       child: Obx(() => getProductItem(products, index)),
//     );
//   }

//   void getToMyProduct(int index);

//   Future<dynamic> getProductDeleteDialog(List<dynamic> products, int index) {
//     return Get.defaultDialog(
//         title: 'Delete Grocery',
//         middleText: products[index].name.value,
//         onCancel: () => Get.back(),
//         buttonColor: Colors.redAccent,
//         confirmTextColor: Colors.white,
//         cancelTextColor: Colors.black,
//         onConfirm: () {
//           products.removeAt(index);
//           Get.back();
//         });
//   }

//   Obx getProductItem(List<dynamic> products, int index) {
//     var grocery = products[index];

//     return Obx(() => Card(
//             child: ListTile(
//           title: getProductName(grocery),
//           subtitle: getProductCategory(grocery),
//           leading: getProductCheckbox(products!, index),
//           trailing: getProductQuantity(grocery),
//         )));
//   }

//   Text getProductName(Grocery grocery) {
//     return Text(grocery.name.value,
//         style: TextStyle(decoration: getTextDecoration(grocery)));
//   }

//   Text getProductCategory(Grocery grocery) {
//     return Text(grocery.category.value,
//         style: TextStyle(
//             color: Colors.grey,
//             fontSize: 13,
//             decoration: getTextDecoration(grocery)));
//   }

//   TextDecoration getTextDecoration(Grocery grocery) {
//     return grocery.isBought.value
//         ? TextDecoration.lineThrough
//         : TextDecoration.none;
//   }

//   Obx getProductCheckbox(List<dynamic> products, int index) {
//     var grocery = products[index];

//     return Obx(() => Checkbox(
//           value: grocery.isBought.value,
//           onChanged: (isEnabled) {
//             grocery.isBought.value = !grocery.isBought.value;
//             if (grocery.isBought.value) {
//               products.removeAt(index);
//               products.add(grocery);
//             }
//           },
//         ));
//   }

//   Text getProductQuantity(Grocery grocery) {
//     return Text(grocery.quantity.value.toString(),
//         style: TextStyle(
//             color: Colors.grey,
//             fontSize: 13,
//             decoration: getTextDecoration(grocery)));
//   }
// }
