//
//  Month.swift
//  CalendarTest3
//
//  Created by Vasyl Nadtochii on 12.02.2022.
//  Copyright (c) 2022 StarGo. All rights reserved.
//


import SwiftUI

struct MonthView<DateView>: View where DateView: View {
    @ObservedObject var viewModel: MonthViewModel
    
    let screenWidth = UIScreen.main.bounds.size.width
    let content: (Date, (() -> Void)?) -> DateView
    
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
            header(for: viewModel.month)
            daysBar()
            
            Divider()
            
            ForEach(viewModel.weeks, id: \.self) { week in
                WeekView(viewModel: WeekViewModel(week: week, forMonth: viewModel.month,
                                                  habit: viewModel.habit,
                                                  calendar: viewModel.calendar), content: content)
                    .frame(height: screenWidth / 7 - 10)
            }
            
            Spacer()
        }
    }
}
