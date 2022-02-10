//
//  ContentView.swift
//  CalendarTest3
//
//  Created by Vasyl Nadtochii on 10.02.2022.
//  Copyright (c) 2022 StarGo. All rights reserved.
//


import SwiftUI

struct ContentView: View {
    @Environment(\.calendar) var calendar

    private var year: DateInterval {
       calendar.dateInterval(of: .year, for: Date())!
    }
    
    var body: some View {
        VStack {
            CalendarView(interval: year) { date in
                CalendarItemView(date: date, handler: {
                    print("You've selected \(date.stringDate)")
                }, screenWidth: UIScreen.main.bounds.size.width)
            }
            .frame(height: UIScreen.main.bounds.size.width + 100)
            
            Spacer()
        }
        .padding(.top)
    }
}

struct Data {
    // setting start date 2 days ago
    static let startDate = Date.now.addingTimeInterval(-86400 * 3)
}

extension Date {
    var stringDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM. d, yyyy"
        
        return dateFormatter.string(from: self)
    }
}

struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let interval: DateInterval
    let content: (Date) -> DateView
    
    @State private var selection = Calendar.current.component(.month, from: Date())

    init(
        interval: DateInterval,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.interval = interval
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
                    MonthView(month: month, content: self.content)
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
    let content: (Date) -> DateView

    init(
        month: Date,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.month = month
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
                    .frame(width: UIScreen.main.bounds.size.width / 7 - 7.5)
            }
        }
    }

    var body: some View {
        VStack {
            header(for: month)
            daysBar()
            
            Divider()
            
            ForEach(weeks, id: \.self) { week in
                WeekView(week: week, content: self.content)
            }
            
            Spacer()
        }
    }
}

struct WeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let week: Date
    let content: (Date) -> DateView

    init(
        week: Date,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.week = week
        self.content = content
    }

    private var days: [Date] {
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week)
            else { return [] }
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        HStack {
            ForEach(days, id: \.self) { date in
                HStack {
                    if self.calendar.isDate(self.week, equalTo: date, toGranularity: .month) {
                        self.content(date)
                    } else {
                        self.content(date).hidden()
                    }
                }
            }
        }
    }
}

fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)

        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }

        return dates
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
