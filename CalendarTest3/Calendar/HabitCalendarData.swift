//
//  Habit.swift
//  CalendarTest3
//
//  Created by Vasyl Nadtochii on 12.02.2022.
//  Copyright (c) 2022 StarGo. All rights reserved.
//


import Foundation

class HabitCalendarData {
    static let shared = HabitCalendarData()
    
    var selectedDates: [Date] = [Date(), Date().dayAfter, Date().dayAfter.dayAfter]
    var startDate = Date().dayBefore.dayBefore.dayBefore
}
