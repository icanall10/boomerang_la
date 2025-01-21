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


struct TimerAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        /// Сколько секунд осталось.
        var timeLeft: Int
        /// Принял ли пользователь «доброе дело».
        var isAccepted: Bool
    }
}

@available(iOS 16.1, *)
class LiveActivityManager: NSObject {

    private var activity: Activity<TimerAttributes>?

    func startActivity(args: [String: Any]?, result: @escaping FlutterResult) {
        // Начальные значения
        let initialContentState = TimerAttributes.ContentState(timeLeft: 40, isAccepted: false)
        let content = ActivityContent(state: initialContentState, staleDate: nil)

        do {
            let activity = try Activity<TimerAttributes>.request(
                attributes: TimerAttributes(),
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
                    
                    let newState = TimerAttributes.ContentState(timeLeft: second, isAccepted: false)
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

    /// Пример: пользователь нажал «Принять»
    func acceptDobroeDelo(args: [String: Any]?, result: @escaping FlutterResult) {
        guard let activity = self.activity else {
            result(FlutterError(code: "NO_ACTIVITY", message: "Нет активной Live Activity", details: nil))
            return
        }
        
        Task {
            // Узнаём текущее состояние
            let currentState = activity.content.state
            // Меняем isAccepted на true
            let newState = TimerAttributes.ContentState(timeLeft: currentState.timeLeft, isAccepted: true)
            let updatedContent = ActivityContent(state: newState, staleDate: nil)
            await activity.update(updatedContent)
            result(nil)
        }
    }

    /// Пример: остановка Live Activity
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
