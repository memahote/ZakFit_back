//
//  Food.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 28/11/2025.
//

import Fluent
import Vapor

final class Food: Model, @unchecked Sendable {
    static let schema = "foods"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name : String
    
    @Field(key: "type")
    var type : String
    
    @Field(key: "protein")
    var protein : Double
    
    @Field(key: "carb")
    var carb : Double
    
    @Field(key: "lipid")
    var lipid: Double
    
    @Field(key: "calorie")
    var calorie: Double
    
    @Field(key: "icon")
    var icon: String
    
    @Siblings(through: MealFood.self, from: \.$food, to: \.$meal)
    var meals: [Meal]
    
    init() {
        
    }
    
    func toDTO()->FoodResponseDTO{
        FoodResponseDTO(
            id: id!,
            name: name,
            type: type,
            protein: protein,
            carb: carb,
            lipid: lipid,
            calorie: calorie,
            icon: icon)
    }
    
}
