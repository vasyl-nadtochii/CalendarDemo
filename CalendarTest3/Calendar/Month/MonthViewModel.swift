//
//  MonthViewModel.swift
//  CalendarTest3
//
//  Created by Vasyl Nadtochii on 12.02.2022.
//  Copyright (c) 2022 StarGo. All rights reserved.
//

import Foundation
import SwiftUI

class MonthViewModel: ObservableObject {
    var calendar: Calendar
    let month: Date
    var habit: HabitCalendarData

    init(
        month: Date,
        calendar: Calendar,
        habit: HabitCalendarData
    ) {
        self.month = month
        self.calendar = calendar
        self.habit = habit
    }

    var weeks: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month)
            else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }
}
