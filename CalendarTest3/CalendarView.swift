//
//  CalendarView.swift
//  CalendarTest3
//
//  Created by Vasyl Nadtochii on 10.02.2022.
//  Copyright (c) 2022 StarGo. All rights reserved.
//


import SwiftUI

struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let interval: DateInterval
    let content: (Date, (() -> Void)?) -> DateView
    
    var data: CalendarData
    
    @State private var selection = Calendar.current.component(.month, from: Date())

    init(
        interval: DateInterval,
        data: CalendarData,
        @ViewBuilder content: @escaping (Date, (() -> Void)?) -> DateView
    ) {
        self.interval = interval
        self.data = data
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
                    MonthView(month: month, data: data, content: self.content)
                        .tag(Calendar.current.component(.month, from: month))
                }
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
}

struct MonthView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let month: Date
    let content: (Date, (() -> Void)?) -> DateView
    var data: CalendarData
    
    let screenWidth = UIScreen.main.bounds.size.width

    init(
        month: Date,
        data: CalendarData,
        @ViewBuilder content: @escaping (Date, (() -> Void)?) -> DateView
    ) {
        self.month = month
        self.data = data
        self.content = content
    }

    private var weeks: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month)
            else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }
    
    private func header(for month: Date) -> some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"

        return HStack {
            Text(formatter.string(from: month))
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
        }
    }
    
    private func daysBar() -> some View {
        let dayNames = ["SU", "MO", "TU", "WE", "TH", "FR", "SA"]
        
        return HStack {
            ForEach(dayNames, id: \.self) { name in
                Text(name)
                    .fontWeight(.light)
                    .foregroundColor((name == "SU") ? Color.red : Color.primary)
                    .frame(width: UIScreen.main.bounds.size.width / 7 - 10)
            }
        }
    }

    var body: some View {
        VStack {
            header(for: month)
            daysBar()
            
            Divider()
            
            ForEach(weeks, id: \.self) { week in
                WeekView(week: week, data: data, forMonth: month, content: self.content)
                    .frame(height: screenWidth / 7 - 10)
                    .environment(\.calendar, {
                        var calendar = Calendar.current
                        calendar.firstWeekday = 1
                        return calendar
                     }())
            }
            
            Spacer()
        }
    }
}

struct WeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let week: Date
    let content: (Date, (() -> Void)?) -> DateView
    var data: CalendarData
    
    let forMonth: Date
    
    let screenWidth = UIScreen.main.bounds.size.width
    var dayItemWidth: CGFloat {
        screenWidth / 7 - 10
    }
    
    // there are actually 6 spacers in week
    var spacerWidth: CGFloat {
        (screenWidth - dayItemWidth * 7) / 8
    }
    
    @State var streaks: [WeekStreak] = []
    
    struct WeekStreak: Hashable {
        var begin: Date? = nil
        var end: Date? = nil
    }

    init(
        week: Date,
        data: CalendarData,
        forMonth: Date,
        @ViewBuilder content: @escaping (Date, (() -> Void)?) -> DateView
    ) {
        self.week = week
        self.data = data
        self.forMonth = forMonth
        self.content = content
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
    
    private func searchForStreaks() {
        var currentStreak: WeekStreak = WeekStreak()
        
        streaks = []
        
        for day in days {
            if data.selectedDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: day) }) { // if it is selected
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
    
    var body: some View {
        ZStack {
            ForEach(streaks, id: \.self) { streak in
                if forMonth.get(.month) == streak.end!.get(.month) {
                    StreakView(dayItemWidth: dayItemWidth, spacerWidth: spacerWidth, streak: streak)
                        .animation(.interactiveSpring(), value: 5.0)
                }
            }
            
            HStack {
                ForEach(days, id: \.self) { date in
                    HStack {
                        if self.calendar.isDate(self.week, equalTo: date, toGranularity: .month) {
                            self.content(date, {
                                searchForStreaks()
                            })
                            .frame(width: dayItemWidth)
                        } else {
                            self.content(date, nil).hidden()
                                .frame(width: dayItemWidth)
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            searchForStreaks()
        })
    }
    
    struct StreakView: View {
        var dayItemWidth: Double
        var spacerWidth: Double
        
        var streak: WeekStreak
        
        var startPos: Int {
            return streak.begin!.dayNumberOfWeek - 1
        }
        
        var endPos: Int {
            return streak.end!.dayNumberOfWeek - 1
        }
        
        var startXCoord: CGFloat {
            return (dayItemWidth / 2) + dayItemWidth * Double(startPos) + spacerWidth * Double(startPos)
        }
        
        var endXCoord: CGFloat {
            return (dayItemWidth / 2) + dayItemWidth * Double(endPos) + spacerWidth * Double(endPos)
        }
        
        var body: some View {
            Path { path in
                path.move(to: CGPoint(x: startXCoord, y: 0))
                
                path.addLine(to: CGPoint(x: endXCoord, y: 0))
                path.addLine(to: CGPoint(x: endXCoord, y: dayItemWidth))
                
                path.addLine(to: CGPoint(x: startXCoord, y: dayItemWidth))
            }
            .fill(.green)
            .padding(.leading, 10)
            .padding(.trailing, 10)
        }
    }
}
