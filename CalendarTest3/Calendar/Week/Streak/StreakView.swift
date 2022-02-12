//
//  StreakView.swift
//  CalendarTest3
//
//  Created by Vasyl Nadtochii on 12.02.2022.
//  Copyright (c) 2022 StarGo. All rights reserved.
//


import SwiftUI

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
