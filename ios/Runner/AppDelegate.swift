import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging
import ActivityKit

struct EmpatingActivityAttributes : ActivityAttributes{
    public struct ContentState: Codable, Hashable {
        let fio: String
        let message: String
        let timerSeconds: Int
        let price: String
        let avatarUrl: String
    }
}


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    // Можно хранить ссылку на Activity, если захотим её завершать (необязательно)
    private var currentActivity: Activity<EmpatingActivityAttributes>?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Регистрируем плагины (Firebase и пр.)
        GeneratedPluginRegistrant.register(with: self)
        
        // Инициируем канал (как в вашем примере на Dart)
        if let controller = window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(name: "foregroundChannel",
                                               binaryMessenger: controller.binaryMessenger)
            
            channel.setMethodCallHandler { [weak self] (call, result) in
                guard let self = self else { return }
                
                switch call.method {
                case "startForegroundService":
                    // Парсим аргументы
                    if let args = call.arguments as? [String: Any] {
                        self.startLiveActivity(args: args)
                    }
                    result(nil)
                    
                case "stopForegroundService":
                    // Если хотите завершать
                    self.stopLiveActivity()
                    result(nil)
                    
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }
        
        // Закрываем настройку
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Функция запуска Live Activity
    private func startLiveActivity(args: [String: Any]) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities отключены в настройках iOS.")
            return
        }
        
        let fio = args["fio"] as? String ?? "Неизвестно"
        let message = args["message"] as? String ?? "Нет сообщения"
        // Обратите внимание: вы передаёте "timerSeconds", а не "timer_seconds"
        // => проверяйте точно ключ.
        let timerSeconds = args["timerSeconds"] as? Int ?? 60
        let price = args["price"] as? String ?? "0"
        let avatarUrl = args["avatarUrl"] as? String ?? ""
        
        // Создаем контент
        let attributes = EmpatingActivityAttributes()
        let state = EmpatingActivityAttributes.ContentState(
            fio: fio,
            message: message,
            timerSeconds: timerSeconds,
            price: price,
            avatarUrl: avatarUrl
        )
        
        // Запрашиваем ActivityKit
        do {
            let activity = try Activity<EmpatingActivityAttributes>.request(
                attributes: attributes,
                contentState: state,
                pushType: .token  // разрешаем обновление через push (если понадоб.)
            )
            self.currentActivity = activity
            print("Live Activity запущена (из Flutter): \(fio), \(message)")
        } catch {
            print("Ошибка при создании Live Activity: \(error)")
        }
    }
    
    // Функция завершения Live Activity (по желанию)
    private func stopLiveActivity() {
        guard let activity = currentActivity else {
            print("Нет активной Live Activity для остановки")
            return
        }
        Task {
            await activity.end(dismissalPolicy: .immediate)
            self.currentActivity = nil
            print("Live Activity остановлена.")
        }
    }
}
