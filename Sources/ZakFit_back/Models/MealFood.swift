//
//  MealFood.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 29/11/2025.
//

import Vapor
import Fluent

final class MealFood: Model,  @unchecked Sendable {
    static let schema = "meal_foods"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "id_meal")
    var meal: Meal
    
    @Parent(key: "id_food")
    var food: Food
    
    @Field(key: "quantity")
    var quantity: Int
    
    @Field(key: "calorie")
    var calorie: Int
    
    init() {}
    
    func toDTO() -> MealFoodResponseDTO {
            MealFoodResponseDTO(
                id: self.id!,
                foodId: self.$food.id,
                quantity: self.quantity,
                calorie: self.calorie
            )
        }
}
