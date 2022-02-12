//
//  CalendarViewModel.swift
//  CalendarTest3
//
//  Created by Vasyl Nadtochii on 12.02.2022.
//  Copyright (c) 2022 StarGo. All rights reserved.
//


import Foundation

class CalendarViewModel: ObservableObject {
    var calendar = Calendar.current
    @Published var notification: String = ""
    @Published var habitCalendarData: HabitCalendarData
    @Published var selection = Calendar.current.component(.month, from: Date())
    
    let interval: DateInterval
    
    init(interval: DateInterval, habitCalendarData: HabitCalendarData) {
        self.interval = interval
        self.habitCalendarData = habitCalendarData
    }
}
