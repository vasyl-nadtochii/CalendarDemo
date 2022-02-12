//
//  CalendarView.swift
//  CalendarTest3
//
//  Created by Vasyl Nadtochii on 10.02.2022.
//  Copyright (c) 2022 StarGo. All rights reserved.
//

import SwiftUI

struct CalendarView<DateView>: View where DateView: View {
    let content: (Date, (() -> Void)?) -> DateView
    @ObservedObject var viewModel: CalendarViewModel
    
    init(viewModel: CalendarViewModel, @ViewBuilder content: @escaping (Date, (() -> Void)?) -> DateView) {
        self.viewModel = viewModel
        self.content = content
    }

    private var months: [Date] {
        viewModel.calendar.generateDates(
            inside: viewModel.interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        SwiftUI.Group {
            TabView(selection: $viewModel.selection) {
                ForEach(months, id: \.self) { month in
                    MonthView(viewModel: MonthViewModel(month: month,
                                                        calendar: viewModel.calendar,
                                                        habit: viewModel.habitCalendarData), content: self.content)
                        .tag(Calendar.current.component(.month, from: month))
                }
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
}
