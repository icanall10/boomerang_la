import 'package:flutter/services.dart';

class TestServiceHelper {
  static const MethodChannel _channel =
      MethodChannel('test_activity');

  static Future<String?> getOne() async{
    try {
      final result = await _channel.invokeMethod('getOne',);
      return result;
    } on PlatformException catch (e) {
      print("Ошибка запуска: '${e.message}'.");
    }
  }

  static Future<String?> getTwo() async{
    try {
      final result = await _channel.invokeMethod('getTwo',);
      return result;
    } on PlatformException catch (e) {
      print("Ошибка запуска: '${e.message}'.");
    }
  }
}

class ForegroundServiceHelper {
  static const MethodChannel _channel =
      MethodChannel('foregroundChannel');

  static Future<void> startForegroundService({
    required String fio,
    required String message,
    required int timerSeconds,
    required String price,
    required String avatarUrl
  }) async {
    try {
      await _channel.invokeMethod('startForegroundService', {
        'fio': fio,
        'message': message,
        'timerSeconds': timerSeconds,
        'price': price,
        'avatarUrl': avatarUrl
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




class LiveActivityHelper {
  static const _channel = MethodChannel('live_activity');

  /// Запускаем новую Live Activity
  /// Возвращает `activityId`
  static Future<String?> startActivity() async {
    try {
      final activityId = await _channel.invokeMethod<String>('startActivity');
      return activityId;
    } on PlatformException catch (e) {
      print("Ошибка запуска Live Activity: $e");
      return null;
    }
  }

  /// Обновляем состояние
  static Future<void> updateActivity(String activityId, int newValue) async {
    try {
      await _channel.invokeMethod('updateActivity', {
        'activityId': activityId,
        'newValue': newValue,
      });
    } on PlatformException catch (e) {
      print("Ошибка обновления Live Activity: $e");
    }
  }

  /// Завершаем
  static Future<void> endActivity(String activityId) async {
    try {
      await _channel.invokeMethod('endActivity', {
        'activityId': activityId,
      });
    } on PlatformException catch (e) {
      print("Ошибка остановки Live Activity: $e");
    }
  }
}