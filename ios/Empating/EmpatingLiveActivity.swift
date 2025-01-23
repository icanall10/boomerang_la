//  EmpatingLiveActivity.swift
//  Empating
//
//  Created by Владимир on 21.01.2025.
//

import ActivityKit
import WidgetKit
import SwiftUI
import LiveActivityModule

@available(iOS 16.1, *)
struct TimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: EmpatingAttributes.self) { context in
            
            LockScreenView(context: context)
            
        } dynamicIsland: { context in
            
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
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
                Image("AppIcon")
            } compactTrailing: {
                Text(context.state.price)
            } minimal: {
                Image(systemName: "person.circle")
            }
        }
    }
}

struct LockScreenView: View {
    let context: ActivityViewContext<EmpatingAttributes>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(spacing: 8) {
                Image("AppIcon")
                    .resizable()
                    .frame(width: 20, height: 20)
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
                            .frame(width: 38, height: 38)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 38, height: 38)
                    case .failure(_):
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 38, height: 38)
                            .clipShape(Circle())
                            .foregroundColor(.gray)
                    @unknown default:
                        Color.gray
                            .frame(width: 38, height: 38)
                            .clipShape(Circle())
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(context.state.fio)
                        .font(.body)
                        .foregroundColor(.black)
                        .lineLimit(1)
                    
                    Text(context.state.message)
                        .foregroundColor(.black)
                        .font(.caption)
                        .lineLimit(2)
                    HStack(spacing: 4) {
                        Text("* За пропуск доната вы потеряете")
                            .foregroundColor(.secondary)
                        
                        Text("-4м")
                            .foregroundColor(.red)
                        
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "#FCE000"), Color(hex: "#FCA600")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                                .frame(width: 16, height: 16)
                            
                            Text("М")
                                .font(.caption2)
                                .foregroundColor(.black)
                        }
                    }
                    .font(.caption)
                }
            }
            .frame(maxWidth: .infinity)
            Button {
                print("Нажата кнопка 'Сделать добро'")
            } label: {
                HStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 1)
                            .frame(width: textWidth(context.state.timeLeft), height: 30)
                            .overlay(
                                Text("\(context.state.timeLeft) СЕК")
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: true, vertical: false)
                            )
                    }
                    
                    Spacer()
                    
                    Text("Сделать добро")
                        .foregroundColor(.black)
                        .fixedSize(horizontal: true, vertical: false)
                    
                    Text("\(context.state.price)₽")
                        .foregroundColor(.black)
                        .fixedSize(horizontal: true, vertical: false)
                }
                .frame(maxWidth: .infinity)
                .padding(6)
                .background(Color.yellow)
                .cornerRadius(26)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = Double((rgbValue >> 16) & 0xff) / 255
        let green = Double((rgbValue >> 8) & 0xff) / 255
        let blue = Double(rgbValue & 0xff) / 255
        self.init(red: red, green: green, blue: blue)
    }
}

private func textWidth(_ timeLeft: Int) -> CGFloat {
    let text = "\(timeLeft) СЕК"
    let font = UIFont.systemFont(ofSize: 17)
    let attributes = [NSAttributedString.Key.font: font]
    let size = text.size(withAttributes: attributes)
    return size.width + 16
}
