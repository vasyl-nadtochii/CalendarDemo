//
//  WeekViewModel.swift
//  CalendarTest3
//
//  Created by Vasyl Nadtochii on 12.02.2022.
//  Copyright (c) 2022 StarGo. All rights reserved.
//


import Foundation

class WeekViewModel: ObservableObject {
    var calendar: Calendar
    let week: Date
    let forMonth: Date
    var habit: HabitCalendarData
    
    @Published var streaks: [WeekStreak] = []
    func searchForStreaks() {
        var currentStreak: WeekStreak = WeekStreak()
        
        streaks = []
        
        for day in days {
            if habit.selectedDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: day) }) { // if it is selected
                if currentStreak.begin == nil {
                    currentStreak.begin = day
                }
                else {
                    currentStreak.end = day
                    
                    if day.dayNumberOfWeek == 7 || day == day.endOfMonth() { // if it is last selected in week or month
                        streaks.append(currentStreak)
                        currentStreak = WeekStreak()
                    }
                }
            }
            else {  // if it is not a selected one
                // if streak has start, end and they are not the same
                if let begin = currentStreak.begin,
                   let end = currentStreak.end {
                    if !Calendar.current.isDate(begin, inSameDayAs: end) {
                        streaks.append(currentStreak)
                        currentStreak = WeekStreak()
                    }
                }
                else {
                    currentStreak = WeekStreak()
                }
            }
        }
    }
    
    init(
        week: Date,
        forMonth: Date,
        habit: HabitCalendarData,
        calendar: Calendar
    ) {
        self.week = week
        self.forMonth = forMonth
        self.habit = habit
        self.calendar = calendar
    }
    
    var days: [Date] {
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week)
            else { return [] }
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )

    }
}
