import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../controllers/products_controller.dart';
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
    final ProductsController<PantryItemModel> pantryController =
        Get.find<ProductsController<PantryItemModel>>();
    int listSize = pantryController.getListSizeFromAll();

    for (int index = 0; index < listSize; index++) {
      PantryItemModel pantryItem = pantryController.getProductFromAll(index)!;
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

  DateTime getTimeOfExpiryNotification(PantryItemModel pantryItem) {
    TimeOfDay notificationTime = pantryItem.expiryNotificationHour.value;
    int daysBeforeNotify = pantryItem.daysBeforeNotify.value;
    DateTime expiryDateNotification =
        pantryItem.expiryDate.value.subtract(Duration(days: daysBeforeNotify));
    DateTime finalExpiryDateNotification = DateTime(
        expiryDateNotification.year,
        expiryDateNotification.month,
        expiryDateNotification.day,
        notificationTime.hour,
        notificationTime.minute,
        0);

    return finalExpiryDateNotification;
  }

  void scheduleNotificationForItem(PantryItemModel pantryItem) {
    DateTime expiryDate = pantryItem.expiryDate.value;
    String pantryItemName = pantryItem.name.value;
    DateTime notificationDate = getTimeOfExpiryNotification(pantryItem);

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
