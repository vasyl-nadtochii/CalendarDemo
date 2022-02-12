//
//  DayViewModel.swift
//  CalendarTest3
//
//  Created by Vasyl Nadtochii on 13.02.2022.
//  Copyright (c) 2022 StarGo. All rights reserved.
//


import Foundation

class DayViewModel: ObservableObject {
    let date: Date
    
    let handler: () -> Void
    let streakHandler: () -> Void
    
    var habit: HabitCalendarData
    
    @Published var status: ItemStatus = .past
    
    enum ItemStatus {
        case past, today, future, selected, missed
    }
    
    func getStatusForDate() {
        for selectedDate in habit.selectedDates {
            if Calendar.current.isDate(selectedDate, inSameDayAs: date) {
                status = .selected
                return
            }
        }
        
        if Calendar.current.isDateInToday(date) {
            status = .today
        }
        else if date < habit.startDate {
            status = .past
        }
        else if date >= habit.startDate && date < Date() {
            status = .missed
        }
        else {
            status = .future
        }
    }
    
    init(
        date: Date,
        handler: @escaping () -> Void,
        streakHandler: @escaping () -> Void,
        habit: HabitCalendarData
    ) {
        self.date = date
        self.habit = habit
        self.handler = handler
        self.streakHandler = streakHandler
    }
}
