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
    @State var notification: String = ""

    private var year: DateInterval {
       calendar.dateInterval(of: .year, for: Date())!
    }
    
    var body: some View {
        VStack {
            CalendarView(interval: year) { date in
                CalendarItemView(date: date, handler: {
                    if Calendar.current.isDateInToday(date) {
                        notification = "Keep going! :)"
                    }
                    else if date >= Data.startDate && date < Date() {
                        notification = "I missed you :("
                    }
                    else {
                        notification = "Seems like someone's cheating -_-"
                    }
                }, screenWidth: UIScreen.main.bounds.size.width)
            }
            .frame(height: UIScreen.main.bounds.size.width + 100)
            
            Text(notification)
            
            Spacer()
        }
        .padding(.top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
