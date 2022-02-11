//
//  Data.swift
//  CalendarTest3
//
//  Created by Vasyl Nadtochii on 10.02.2022.
//  Copyright (c) 2022 StarGo. All rights reserved.
//


import Foundation
import SwiftUI

class CalendarData: ObservableObject {
    // setting start date 2 days ago
    static let shared = CalendarData()
    
    let startDate = Date.now.addingTimeInterval(-86400 * 3)
    @Published var selectedDates: [Date] = []
}
