//
//  Month.swift
//  CalendarTest3
//
//  Created by Vasyl Nadtochii on 12.02.2022.
//  Copyright (c) 2022 StarGo. All rights reserved.
//


import SwiftUI

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
