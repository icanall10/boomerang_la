import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:boomerang/classes/foreground_service_helper.dart';
import 'package:boomerang/classes/helpers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';

class FCM {
  static FCM instance() {
    return GetIt.instance<FCM>();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await FirebaseMessaging.instance.subscribeToTopic('all');

    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
    FirebaseMessaging.onMessage.listen(firebaseMessagingForegroundHandler);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await FlutterLocalNotificationsPlugin().initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
          onDidReceiveLocalNotification: onDidReceiveLocalNotification,
        ),
      ),
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
    if(Platform.isAndroid){
      final token = await FirebaseMessaging.instance.getToken();
      print('---Your token for push test: $token');
    }
    if(Platform.isIOS){
      final token = await FirebaseMessaging.instance.getAPNSToken();
      print('---Your token for push test: $token');
    }

  }

  void onMessageOpenedApp(RemoteMessage message) {
    dd('---onMessageOpenedApp');
    showForegroundNotification(message.data);

    _handleMessageData(message.data);
  }

  Future<bool> handleInitialMessage() async {
    dd('---handleInitialMessage');

    RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();

    if (message == null) return false;

    onMessageOpenedApp(message);

    return true;
  }

  Future<String?> getDeviceToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  void _onDidReceiveNotificationResponse(NotificationResponse details) {
    dd('---_onDidReceiveNotificationResponse');

    final Map<String, dynamic> data = Map<String, dynamic>.from(jsonDecode(details.payload ?? '{}'));

    _handleMessageData(data);
  }
}

@pragma('vm:entry-point')
void _handleMessageData(Map<String, dynamic> data) {
  dd('---_handleMessageData');
  print(data);
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingForegroundHandler(RemoteMessage message) async {
  showForegroundNotification(message.data);
  dd('---_firebaseMessagingForegroundHandler');
  print(message.data);
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  dd('---_firebaseMessagingBackgroundHandler');
  print(message.data);
}

@pragma('vm:entry-point')
void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
  dd('---_onDidReceiveLocalNotification');
  print(payload);
}

@pragma('vm:entry-point')
Future<void> showForegroundNotification(Map<String, dynamic> data) async {
  final fio = data['fio'] ?? 'Неизвестно';
  final message = data['message'] ?? 'Нет сообщения';
  final timerSeconds = int.tryParse(data['timer_seconds'] ?? '60') ?? 60;
  final price = data['price'] ?? '0';
  final avatarUrl = data['avatarUrl'] ?? '0';

  await ForegroundServiceHelper.startForegroundService(
    fio: fio,
    message: message,
    timerSeconds: timerSeconds,
    price: price,
    avatarUrl: avatarUrl
  );
}