//
//  CalendarItemView.swift
//  CalendarTest2
//
//  Created by Vasyl Nadtochii on 09.02.2022.
//  Copyright (c) 2022 StarGo. All rights reserved.
//

import SwiftUI

struct DayView: View {
    let screenWidth: CGFloat
    
    @StateObject var viewModel: DayViewModel
    
    var body: some View {
        Circle()
            .foregroundColor(getBackgroundColor())
            .frame(height: screenWidth / 7 - 10)
            .overlay {
                Text("\(Calendar.current.dateComponents([.day], from: viewModel.date).day!)")
                    .foregroundColor(getForegroundColor())
                    .fontWeight(.semibold)
            }
            .onTapGesture {
                if viewModel.date >= viewModel.habit.startDate {
                    if viewModel.status == .selected { // if we unmark
                        viewModel.habit.selectedDates.removeAll(where: { date in
                            Calendar.current.isDate(viewModel.date, inSameDayAs: date)
                        })
                        viewModel.getStatusForDate()
                        
                        unmarkVibration()
                    }
                    else { // if we mark
                        viewModel.status = .selected
                        markVibration()
                        viewModel.handler()
                    }
                    
                    viewModel.streakHandler()
                }
            }
            .onAppear(perform: {
                viewModel.getStatusForDate()
            })
    }
    
    func markVibration() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    func unmarkVibration() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
    
    func getBackgroundColor() -> Color {
        switch viewModel.status {
        case .past:
            return .clear
        case .today:
            return .accentColor
        case .future:
            return .gray.opacity(0.5)
        case .selected:
            return .green
        case .missed:
            return .red
        }
    }
    
    func getForegroundColor() -> Color {
        switch viewModel.status {
        case .past:
            return .gray.opacity(0.4)
        case .today, .future, .selected, .missed:
            return .white
        }
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(screenWidth: UIScreen.main.bounds.size.width,
                viewModel: DayViewModel(date: Date(), handler: { },
                                        streakHandler: { }, habit: HabitCalendarData()))
    }
}

