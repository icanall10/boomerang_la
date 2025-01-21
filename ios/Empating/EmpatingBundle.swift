//
//  EmpatingBundle.swift
//  Empating
//
//  Created by Владимир on 21.01.2025.
//

import WidgetKit
import SwiftUI

@main
struct EmpatingBundle: WidgetBundle {
    var body: some Widget {
            if #available(iOS 16.1, *) {
                TimerLiveActivity()
            }
        }
}
