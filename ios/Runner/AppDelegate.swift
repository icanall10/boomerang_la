import UIKit
import Flutter
import LiveActivityModule

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    var liveActivityManager: LiveActivityManager?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
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
}
