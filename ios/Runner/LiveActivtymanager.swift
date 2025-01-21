//
//  LiveActivtymanager.swift
//  Runner
//
//  Created by Владимир on 21.01.2025.
//

import Foundation
import Foundation
import ActivityKit
import Flutter


struct EmpatingAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        let fio: String
        let message: String
        let avatarUrl: String
        let price: String
        /// Сколько секунд осталось.
        var timeLeft: Int
        /// Принял ли пользователь «доброе дело».
        var isAccepted: Bool
    }
}

@available(iOS 16.1, *)
class LiveActivityManager: NSObject {

    private var activity: Activity<EmpatingAttributes>?

    func startActivity(args: [String: Any]?, result: @escaping FlutterResult) {
        guard let args = args else {
                // Обработка случая, когда args равен nil
                result(FlutterError(code: "INVALID_ARGS", message: "Arguments are nil", details: nil))
                return
            }
        
        let fio = args["fio"] as? String ?? "Неизвестно"
        let message = args["message"] as? String ?? "Нет сообщения"
        let timerSeconds = args["timerSeconds"] as? Int ?? 60
        let price = args["price"] as? String ?? "0"
        let avatarUrl = args["avatarUrl"] as? String ?? ""
        // Начальные значения
        let initialContentState = EmpatingAttributes.ContentState(fio: fio, message: message, avatarUrl: avatarUrl, price: price, timeLeft: timerSeconds, isAccepted: false)
        let content = ActivityContent(state: initialContentState, staleDate: nil)

        do {
            let activity = try Activity<EmpatingAttributes>.request(
                attributes: EmpatingAttributes(),
                content: content,
                pushType: nil
            )
            self.activity = activity

            // Вернём ID
            result(activity.id)

            // Запустим таймер (каждую секунду уменьшаем timeLeft, пока он > 0)
            Task {
                for second in stride(from: 39, through: 0, by: -1) {
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    
                    // Если уже приняли - можно прервать таймер
                    let currentState = activity.content.state
                    if currentState.isAccepted {
                        break
                    }
                    
                    let newState = EmpatingAttributes.ContentState(fio: currentState.fio, message: currentState.message, avatarUrl: currentState.avatarUrl, price: currentState.price, timeLeft: second, isAccepted: false)
                    let updatedContent = ActivityContent(state: newState, staleDate: nil)
                    await activity.update(updatedContent)
                }
            }

        } catch {
            result(FlutterError(code: "START_FAILED",
                                message: "Не удалось запустить Live Activity: \(error.localizedDescription)",
                                details: nil))
        }
    }

    func acceptDobroeDelo(args: [String: Any]?, result: @escaping FlutterResult) {
        guard let activity = self.activity else {
            result(FlutterError(code: "NO_ACTIVITY", message: "Нет активной Live Activity", details: nil))
            return
        }
        
        Task {
            let currentState = activity.content.state
            let newState = EmpatingAttributes.ContentState(fio: currentState.fio, message: currentState.message, avatarUrl: currentState.avatarUrl, price: currentState.price, timeLeft: currentState.timeLeft, isAccepted: true)
            let updatedContent = ActivityContent(state: newState, staleDate: nil)
            await activity.update(updatedContent)
            result(nil)
        }
    }

    func endActivity(args: [String: Any], result: @escaping FlutterResult) {
        guard let activity = self.activity else {
            result(FlutterError(code: "NOT_FOUND", message: "Live Activity не найдена", details: nil))
            return
        }

        Task {
            await activity.end(dismissalPolicy: .immediate)
            self.activity = nil
            result(nil)
        }
    }
}
