//
//  Week.swift
//  CalendarTest3
//
//  Created by Vasyl Nadtochii on 12.02.2022.
//  Copyright (c) 2022 StarGo. All rights reserved.
//


import SwiftUI

struct WeekView<DateView>: View where DateView: View {
    @StateObject var viewModel: WeekViewModel
    let content: (Date, (() -> Void)?) -> DateView
    
    let screenWidth = UIScreen.main.bounds.size.width
    var dayItemWidth: CGFloat {
        screenWidth / 7 - 10
    }
    
    var spacerWidth: CGFloat {
        (screenWidth - dayItemWidth * 7) / 8
    }
    
    var body: some View {
        ZStack {
            ForEach(viewModel.streaks, id: \.self) { streak in
                if viewModel.forMonth.get(.month) == streak.end!.get(.month) {
                    StreakView(dayItemWidth: dayItemWidth, spacerWidth: spacerWidth, streak: streak)
                        .animation(.interactiveSpring(), value: 5.0)
                }
            }
            
            HStack {
                ForEach(viewModel.days, id: \.self) { date in
                    HStack {
                        if viewModel.calendar.isDate(viewModel.week, equalTo: date, toGranularity: .month) {
                            content(date, {
                                viewModel.searchForStreaks()
                            })
                            .frame(width: dayItemWidth)
                        } else {
                            content(date, nil).hidden()
                                .frame(width: dayItemWidth)
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            viewModel.searchForStreaks()
        })
    }
}
