//
//  DateExtension.swift
//  Aadat
//
//  Created by Sauvikesh Lal on 3/12/24.
//

import Foundation

extension Date {
    func diff(numDays: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: numDays, to: self)!
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
