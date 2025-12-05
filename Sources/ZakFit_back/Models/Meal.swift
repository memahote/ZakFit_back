//
//  Meal.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 29/11/2025.
//

import Fluent
import Vapor

final class Meal: Model, @unchecked Sendable {
    static let schema = "meals"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "type")
    var type: String
    
    @Field(key: "created_at")
    var createdAt: Date
    
    @Parent(key: "user_id")
    var user: User
    
    @Siblings(through: MealFood.self, from: \.$meal, to: \.$food)
    var foods: [Food]
    
    init(){ }
    
    func toDTO(foods: [MealFoodResponseDTO]) -> MealResponseDTO {
            MealResponseDTO(
                id: self.id!,
                type: self.type,
                createdAt: self.createdAt,
                foods: foods
            )
        }
}
