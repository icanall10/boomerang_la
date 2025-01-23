//
//  EmpatingAttributes.swift
//  LiveActivityModule
//
//  Created by Владимир on 21.01.2025.
//

import Foundation
import ActivityKit


public struct EmpatingAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public let fio: String
        public let message: String
        public let avatarUrl: String
        public let price: String
        /// Сколько секунд осталось.
        public var timeLeft: Int
        /// Принял ли пользователь «доброе дело».
        public var isAccepted: Bool
    }
}
