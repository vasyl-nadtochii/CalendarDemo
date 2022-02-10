//
//  CalendarItemView.swift
//  CalendarTest2
//
//  Created by Vasyl Nadtochii on 09.02.2022.
//  Copyright (c) 2022 StarGo. All rights reserved.
//

import SwiftUI

struct CalendarItemView: View {
    let date: Date
    let handler: () -> Void
    var data: CalendarData
    
    let screenWidth: CGFloat
    
    @State var status: ItemStatus = .past
    
    var body: some View {
        Button {
            if date >= data.startDate {
                if status == .selected {
                    data.selectedDates.removeAll(where: { date in
                        Calendar.current.isDate(self.date, inSameDayAs: date)
                    })
                    getStatusForDate()
                }
                else {
                    status = .selected
                    simpleSuccess()
                    handler()
                }
            }
        } label: {
            Circle()
                .foregroundColor(getBackgroundColor())
                .frame(height: screenWidth / 7 - 10)
                .overlay {
                    Text("\(Calendar.current.dateComponents([.day], from: date).day!)")
                        .foregroundColor(getForegroundColor())
                        .fontWeight(.semibold)
                }
        }
        .onAppear(perform: {
            getStatusForDate()
        })
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func getStatusForDate() {
        for selectedDate in data.selectedDates {
            if Calendar.current.isDate(selectedDate, inSameDayAs: date) {
                status = .selected
                return
            }
        }
        
        if Calendar.current.isDateInToday(date) {
            status = .today
        }
        else if date < data.startDate {
            status = .past
        }
        else if date >= data.startDate && date < Date() {
            status = .missed
        }
        else {
            status = .future
        }
    }
    
    func getBackgroundColor() -> Color {
        switch status {
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
        switch status {
        case .past:
            return .gray.opacity(0.4)
        case .today, .future, .selected, .missed:
            return .white
        }
    }
}

extension CalendarItemView {
    enum ItemStatus {
        case past, today, future, selected, missed
    }
}

struct CalendarItemView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarItemView(date: Date(), handler: { }, data: CalendarData(), screenWidth: UIScreen.main.bounds.size.width)
    }
}

