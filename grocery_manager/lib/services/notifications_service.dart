import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../controllers/my_products_controller.dart';
import '../models/pantry_item_model.dart';

class NotificationsService extends GetxService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationDetails? notificationDetails;
  final Map<PantryItemModel, int> _pantryItemNotificationIds =
      <PantryItemModel, int>{};
  int maximumId = 0;

  NotificationsService() {
    _initNotificationService();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('expiration', 'expiration',
            importance: Importance.max,
            priority: Priority.high,
            icon: "app_icon");

    notificationDetails =
        const NotificationDetails(android: androidPlatformChannelSpecifics);

    scheduleAllNotifications();
  }

  Future<void> _initNotificationService() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('drawable/app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) => {},
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'expiration', // Replace with your own channel ID
      'expiration', // Replace with your own channel name
      importance: Importance.max,
    );

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    tz.initializeTimeZones();
  }

  void scheduleAllNotifications() {
    final MyProductsController<PantryItemModel> myPantryController =
        Get.find<MyProductsController<PantryItemModel>>();
    int listSize = myPantryController.getListSizeFromAll();

    for (int index = 0; index < listSize; index++) {
      PantryItemModel pantryItem = myPantryController.getProductFromAll(index)!;
      if (pantryItem.expiryDate.value.compareTo(PantryItemModel.defaultDate) ==
          0) {
        continue;
      }
      scheduleNotificationForItem(pantryItem);
    }
  }

  Future<void> cancelNotificationFor(PantryItemModel pantryItem) async {
    await flutterLocalNotificationsPlugin
        .cancel(_pantryItemNotificationIds[pantryItem]!);
    _pantryItemNotificationIds.remove(pantryItem);
  }

  void scheduleNotificationForItem(PantryItemModel pantryItem) {
    int daysBeforeNotify = pantryItem.daysBeforeNotify.value;
    DateTime notificationDate =
        pantryItem.expiryDate.value.subtract(Duration(days: daysBeforeNotify));
    DateTime expiryDate = pantryItem.expiryDate.value;
    String pantryItemName = pantryItem.name.value;

    scheduleNotification(
        notificationId: maximumId,
        productName: pantryItemName,
        expiryDate: expiryDate,
        notificationDate: notificationDate);

    maximumId += 1;
  }

  Future<void> scheduleNotification(
      {required int notificationId,
      required String productName,
      required DateTime expiryDate,
      required DateTime notificationDate}) async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId, // Notification ID
      '$productName expires soon', // Notification title
      '$productName will expire on: ${expiryDate.day}/${expiryDate.month}', // Notification body
      tz.TZDateTime.from(notificationDate, tz.local), // Scheduled time
      notificationDetails!,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
