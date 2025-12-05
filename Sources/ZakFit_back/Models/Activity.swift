//
//  Activity.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 01/12/2025.
//

import Fluent
import Vapor

final class Activity: Model, @unchecked Sendable {
    static let schema = "activities"
    
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "category")
    var category: String
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "calories_per_min")
    var caloriesPerMin: Double
    
    @Field(key: "icon")
    var icon: String
    
    
    init() { }
    
    func toDTO()->ActivityResponseDTO{
        ActivityResponseDTO(
            id: self.id!,
            category: self.category,
            name: self.name,
            caloriesPerMin: self.caloriesPerMin,
            icon: self.icon)
    }
    
}
