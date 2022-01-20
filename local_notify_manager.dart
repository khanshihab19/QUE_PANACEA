import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:que_panacea/model/reminder.dart';
import 'dart:io' show Platform;
import 'package:rxdart/subjects.dart';

class LocalNotifyManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initSetting;

  BehaviorSubject<ReceiveNotification> get didReceiveLocalNotificationSubject =>
      BehaviorSubject<ReceiveNotification>();

  LocalNotifyManager.init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    if (Platform.isIOS) {
      requestIOSPermissions();
    }

    initializePlatform();
  }

  requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  initializePlatform() {
    var initSettingAndroid =
        AndroidInitializationSettings('app_notification_icon');
    var initSettingIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceiveNotification notification = ReceiveNotification(
              id: id, title: title, body: body, payload: payload);
          didReceiveLocalNotificationSubject.add(notification);
        });

    initSetting = InitializationSettings(
        android: initSettingAndroid, iOS: initSettingIOS);
  }

  setOnNotificationReceive(Function onNotificationReceive) {
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> showNotification(DateTime selectedDate) async {
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
      icon: 'icon_notification_replace',
      largeIcon: DrawableResourceAndroidBitmap('icon_large_notification'),
      timeoutAfter: 5000,
      enableLights: true,
    );

    var iOSChannel = IOSNotificationDetails(sound: 'notification_sound.mp3');

    var platformChannel = NotificationDetails(
      android: androidChannel,
      iOS: iOSChannel,
    );

    await flutterLocalNotificationsPlugin.show(
        0, 'Test Title', 'Test Body', platformChannel,
        payload: 'New Payload');

    print('Notification Showed');
  }

  Future<void> scheduleNotification(Reminder reminder) async {
    var scheduleNotificationDateTime = reminder.dateTime;
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
      icon: 'icon_notification_replace',
      largeIcon: DrawableResourceAndroidBitmap('icon_large_notification'),
      timeoutAfter: 10000,
      enableLights: true,
    );

    var iOSChannel = IOSNotificationDetails(sound: 'notification_sound.mp3');

    var platformChannel = NotificationDetails(
      android: androidChannel,
      iOS: iOSChannel,
    );

    await flutterLocalNotificationsPlugin.schedule(reminder.reminderId, reminder.title,
        reminder.description, scheduleNotificationDateTime, platformChannel,
        payload: 'Schedule New Payload');
  }

  Future<void> repeatNotification() async {
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
      icon: 'icon_notification_replace',
      largeIcon: DrawableResourceAndroidBitmap('icon_large_notification'),
      timeoutAfter: 5000,
      enableLights: true,
    );

    var iOSChannel = IOSNotificationDetails(sound: 'notification_sound.mp3');

    var platformChannel = NotificationDetails(
      android: androidChannel,
      iOS: iOSChannel,
    );


    await flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        'Repeat Test Title',
        'Repeat Test Body',
        RepeatInterval.everyMinute,
        platformChannel,
        payload: 'New Payload');
  }

  Future<void> showDailyAtTimeNotification() async {
    var time = Time(21, 53, 0);
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
      icon: 'icon_notification_replace',
      largeIcon: DrawableResourceAndroidBitmap('icon_large_notification'),
      timeoutAfter: 5000,
      enableLights: true,
    );

    var iOSChannel = IOSNotificationDetails(sound: 'notification_sound.mp3');

    var platformChannel = NotificationDetails(
      android: androidChannel,
      iOS: iOSChannel,
    );

    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0, 'Daily Test Title', 'Daily Test Body',time, platformChannel,
        payload: 'Daily New Payload');
  }

  Future <void> cancelNotification(int id) async{
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future <void> cancelAllNotification() async{
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

LocalNotifyManager localNotifyManager = LocalNotifyManager.init();

class ReceiveNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceiveNotification(
      {@required this.id,
      @required this.title,
      @required this.body,
      @required this.payload});
}
