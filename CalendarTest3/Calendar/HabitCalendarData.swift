//
//  Habit.swift
//  CalendarTest3
//
//  Created by Vasyl Nadtochii on 12.02.2022.
//  Copyright (c) 2022 StarGo. All rights reserved.
//


import Foundation

class HabitCalendarData {
    var selectedDates: [Date] = [Date(), Date().dayAfter, Date().dayAfter.dayAfter]
    var startDate: Date
    
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        startDate = dateFormatter.date(from: "2022-02-09")!
    }
}
