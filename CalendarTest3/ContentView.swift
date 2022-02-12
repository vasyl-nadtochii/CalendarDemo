//
//  ContentView.swift
//  CalendarTest3
//
//  Created by Vasyl Nadtochii on 10.02.2022.
//  Copyright (c) 2022 StarGo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: CalendarViewModel =
        CalendarViewModel(interval: Calendar.current.dateInterval(of: .year, for: Date())!,
                          habitCalendarData: HabitCalendarData())
    
    var body: some View {
        VStack {
            CalendarView(viewModel: viewModel) { date, streakHandler in
                DayView(screenWidth: UIScreen.main.bounds.size.width,
                        viewModel: DayViewModel(date: date, handler: {
                    if Calendar.current.isDateInToday(date) {
                        viewModel.notification = "Keep going! :)"
                    }
                    else if date >= viewModel.habitCalendarData.startDate && date < Date() {
                        viewModel.notification = "I missed you :("
                    }
                    else {
                        viewModel.notification = "Seems like someone's cheating -_-"
                    }
                    
                    viewModel.habitCalendarData.selectedDates.append(date)
                    
                    // here we can also do some stuff with the DataManager
                }, streakHandler: streakHandler ?? { print("NO STREAK HANDLER") },
                        habit: viewModel.habitCalendarData))
            }
            .frame(height: UIScreen.main.bounds.size.width + 100)
            
            Text(viewModel.notification)
            
            Spacer()
        }
        .padding(.top)
        .onAppear {
            viewModel.calendar.firstWeekday = 1
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
