//
//  EmpatingLiveActivity.swift
//  Empating
//
//  Created by Владимир on 21.01.2025.
//

import ActivityKit
import WidgetKit
import SwiftUI


struct TimerAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        /// Сколько секунд осталось.
        var timeLeft: Int
        /// Принял ли пользователь «доброе дело».
        var isAccepted: Bool
    }
}

@available(iOS 16.1, *)
struct TimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            // Вид на экране блокировки (или в полном режиме Dynamic Island)
            LockScreenView(context: context)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded region
                DynamicIslandExpandedRegion(.center) {
                    LockScreenView(context: context)
                }

            } compactLeading: {
                // Мини-иконка слева
                Text("DD") // "Доброе дело" (заглушка)
            } compactTrailing: {
                // Мини-иконка справа
                Text(context.state.timeLeft > 0 ? "\(context.state.timeLeft)s" : "0s")
            } minimal: {
                // Самая компактная форма
                Text("DD")
            }
            .widgetURL(URL(string: "myapp://open-dobroe-delo")) // чтобы по тапу открыть приложение
        }
    }
}

/// Вспомогательная вьюха, чтобы не дублировать код
struct LockScreenView: View {
    let context: ActivityViewContext<TimerAttributes>
    
    var body: some View {
        VStack(spacing: 8) {
            // Если ещё не приняли
            if !context.state.isAccepted {
                Text("У вас новое доброе дело")
                    .font(.headline)
                
                if context.state.timeLeft > 0 {
                    // Показываем кнопку «Принять»
                    Button("Принять") {
                        // Обычно тут просто ссылку (widgetURL) или открытие приложения.
                        // Прямо «внутри» виджета нажать и изменить состояние нельзя.
                    }
                    .buttonStyle(.borderedProminent)
                    
                    // Показываем, сколько осталось секунд
                    Text("Осталось: \(context.state.timeLeft) c")
                        .font(.subheadline)
                } else {
                    // Время вышло
                    Text("Вы не успели")
                        .foregroundColor(.red)
                }
            } else {
                // Пользователь успел нажать «Принять»
                Text("Вы приняли доброе дело!")
                    .font(.title3)
                    .foregroundColor(.green)
            }
        }
    }
}
