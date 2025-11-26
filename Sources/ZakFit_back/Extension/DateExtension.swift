//
//  DateExtension.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 26/11/2025.
//

import Fluent
import Vapor

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "FR")
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
}
