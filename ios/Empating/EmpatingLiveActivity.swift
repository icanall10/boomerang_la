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
struct TimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            
            // Lock Screen / Banner view
            LockScreenView(context: context)
            
        } dynamicIsland: { context in
            
            DynamicIsland {
                // Expanded (при долгом тапе)
                DynamicIslandExpandedRegion(.leading) {
                    // Вывод таймера (убывающий)
                    // (iOS 16.2+ автоматически обновляет .timer)
                    Text("\(context.state.timeLeft) СЕК")
                        .font(.headline)
                        .foregroundColor(.red)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(context.state.price)₽")
                        .foregroundColor(.green)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.message)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    LockScreenView(context: context)
                }
                
            } compactLeading: {
                // Сжатое представление (слева)
                Image("AppIcon") // Иконка приложения
            } compactTrailing: {
                // Сжатое представление (справа)
                Text(context.state.price)
            } minimal: {
                // Минимальное представление
                Image(systemName: "person.circle")
            }
        }
    }
}

/// Основная форма
struct LockScreenView: View {
    let context: ActivityViewContext<TimerAttributes>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // (1) Иконка приложения + "ЭМПАТИНГ", по центру
            HStack(spacing: 8) {
                Image("AppIcon") // замените на реальное имя ассета
                    .resizable()
                    .frame(width: 20, height: 20) // Размер иконки
                    .cornerRadius(4)
                
                Text("ЭМПАТИНГ")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            
            // (2) Аватар + fio (чёрный) + message (чёрный)
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: context.state.avatarUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure(_):
                        // Фолбэк (например, иконка)
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFill()
                    @unknown default:
                        Color.gray
                    }
                }
                .frame(width: 38, height: 38)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(context.state.fio)
                        .font(.body)
                        .foregroundColor(.black)
                    
                    Text(context.state.message)
                        .foregroundColor(.black)
                        .font(.caption)
                    
                    // (4) Надпись "* За пропуск доната вы потеряете -4м"
                    // с красным "-4м"
                    (
                        Text("* За пропуск доната вы потеряете ")
                            .foregroundColor(.secondary)
                        +
                        Text("-4м")
                            .foregroundColor(.red)
                    )
                    .font(.caption)
                }
            }
            
            // (3,5) Кнопка с таймером (у нас ниже просто текст),
            // но для реального таймера используем timerInterval.
            // фоновый цвет - желтый, текст - чёрный
            Button {
                print("Нажата кнопка 'Сделать добро'")
            } label: {
                HStack(spacing: 8) {
                    // Убывающий таймер
                    Text("\(context.state.timeLeft) СЕК")
                        .foregroundColor(.red)
                    
                    Text("Сделать добро")
                        .foregroundColor(.black)
                    
                    Text("\(context.state.price)₽")
                        .foregroundColor(.black)
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.yellow)        // Жёлтая кнопка
            .foregroundColor(.black)
        }
        .padding()
    }
}
