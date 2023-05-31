import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{
   NotificationService._();
 static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {

    var initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher'); // <- default icon name is @mipmap/ic_launcher

    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _isAndroidPermissionGranted();
    _requestPermissions();
  await  _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
  }

  static Future<void> _isAndroidPermissionGranted() async {
     if (Platform.isAndroid) {
       final bool granted = await _flutterLocalNotificationsPlugin
           .resolvePlatformSpecificImplementation<
           AndroidFlutterLocalNotificationsPlugin>()
           ?.areNotificationsEnabled() ??
           false;


     }
   }

  static Future<void> _requestPermissions() async {
     if (Platform.isIOS || Platform.isMacOS) {
       await _flutterLocalNotificationsPlugin
           .resolvePlatformSpecificImplementation<
           IOSFlutterLocalNotificationsPlugin>()
           ?.requestPermissions(
         alert: true,
         badge: true,
         sound: true,
       );
       await _flutterLocalNotificationsPlugin
           .resolvePlatformSpecificImplementation<
           MacOSFlutterLocalNotificationsPlugin>()
           ?.requestPermissions(
         alert: true,
         badge: true,
         sound: true,
       );
     } else if (Platform.isAndroid) {
       final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
       _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
           AndroidFlutterLocalNotificationsPlugin>();

       final bool? granted = await androidImplementation?.requestPermission();


     }
   }



 static Future<void> showNotification({

    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      '1',
      'Jual Murah App',
      channelDescription: 'Jual Murah App',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

}