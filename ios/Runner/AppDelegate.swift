import UIKit
import Flutter

@available(iOS 16.1, *)
@main
@objc class AppDelegate: FlutterAppDelegate {
    
    var liveActivityManager: LiveActivityManager?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                    // Обработка разрешения
                }
        
        // Создаём экземпляр LiveActivityManager (если iOS >= 16.1)
        if #available(iOS 16.1, *) {
            liveActivityManager = LiveActivityManager()
        }
        
        // Регистрируем метод-канал
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "foregroundChannel", binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler { [weak self] call, result in
            guard let self = self else { return }
            guard #available(iOS 16.1, *) else {
                result(FlutterError(code: "UNSUPPORTED_VERSION",
                                    message: "Live Activities доступны только на iOS 16.1+",
                                    details: nil))
                return
            }

            switch call.method {
            case "startForegroundService":
                self.liveActivityManager?.startActivity(args: call.arguments as? [String: Any], result: result)
            case "acceptDobroeDelo":
                self.liveActivityManager?.acceptDobroeDelo(args: call.arguments as? [String: Any], result: result)
            case "stopForegroundService":
                self.liveActivityManager?.endActivity(args: call.arguments as? [String: Any] ?? [:], result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        
        Task {
            liveActivityManager?.startActivity(args: userInfo as? [String : Any], result: { _ in })
            completionHandler(.newData)
        }
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification) async
        -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        print(userInfo)

            liveActivityManager?.startActivity(args: userInfo as? [String : Any], result: { _ in })

        return [[.alert, .sound]]
      }

    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo

        // ...

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print full message.
        print(userInfo)
      }

}
