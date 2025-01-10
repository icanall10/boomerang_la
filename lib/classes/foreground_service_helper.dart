import 'package:flutter/services.dart';

class ForegroundServiceHelper {
  static const MethodChannel _channel =
      MethodChannel('foregroundChannel');

  static Future<void> startForegroundService({
    required String fio,
    required String message,
    required int timerSeconds,
    required String price,
  }) async {
    try {
      await _channel.invokeMethod('startForegroundService', {
        'fio': fio,
        'message': message,
        'timerSeconds': timerSeconds,
        'price': price,
      });
    } on PlatformException catch (e) {
      print("Ошибка запуска: '${e.message}'.");
    }
  }

  static Future<void> stopForegroundService() async {
    try {
      await _channel.invokeMethod('stopForegroundService');
    } on PlatformException catch (e) {
      print("Ошибка остановки: '${e.message}'.");
    }
  }
}