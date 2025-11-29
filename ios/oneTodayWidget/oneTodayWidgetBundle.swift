//
//  oneTodayWidgetBundle.swift
//  oneTodayWidget
//
//  Created by yonghee on 11/29/25.
//

import WidgetKit
import SwiftUI

@main
struct oneTodayWidgetBundle: WidgetBundle {
    var body: some Widget {
        oneTodayWidget()
        // 다른 위젯들은 사용하지 않으므로 주석 처리
        // oneTodayWidgetControl()
        // oneTodayWidgetLiveActivity()
    }
}
