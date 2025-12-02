//
//  UserActivityDTO.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 01/12/2025.
//

import Fluent
import Vapor

struct UserActivityDTO: Content {
    let activity: UUID
    let duration: Int
    let calories: Double?
    let date: Date
    
    func toModel() -> UserActivity {
        let model = UserActivity()
        
        model.activity.id = self.activity
        model.duration = self.duration
        model.calories = self.calories
        model.date = self.date
        
        return model
    }
}

struct UserActivityResponseDTO: Content {
    let id: UUID
    let activity: ActivityResponseDTO
    let duration: Int
    let calories: Double?
    let date: Date
}

