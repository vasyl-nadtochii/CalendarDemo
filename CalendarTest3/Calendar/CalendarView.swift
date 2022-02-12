//
//  CalendarView.swift
//  CalendarTest3
//
//  Created by Vasyl Nadtochii on 10.02.2022.
//  Copyright (c) 2022 StarGo. All rights reserved.
//


import SwiftUI

struct CalendarView<DateView>: View where DateView: View {
    var calendar: Calendar

    let interval: DateInterval
    let content: (Date, (() -> Void)?) -> DateView
    
    var data: CalendarData
    
    @State private var selection = Calendar.current.component(.month, from: Date())

    init(
        interval: DateInterval,
        data: CalendarData,
        calendar: Calendar,
        @ViewBuilder content: @escaping (Date, (() -> Void)?) -> DateView
    ) {
        self.interval = interval
        self.data = data
        self.calendar = calendar
        self.content = content
    }

    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        SwiftUI.Group {
            TabView(selection: $selection) {
                ForEach(months, id: \.self) { month in
                    MonthView(month: month, data: data, calendar: calendar, content: self.content)
                        .tag(Calendar.current.component(.month, from: month))
                }
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
}
