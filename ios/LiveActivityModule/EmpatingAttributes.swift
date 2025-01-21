//
//  EmpatingAttributes.swift
//  LiveActivityModule
//
//  Created by Владимир on 21.01.2025.
//

import Foundation
import ActivityKit


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
