//
//  MealFoodDTO.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 29/11/2025.
//

import Fluent
import Vapor


struct MealFoodDTO: Content {
    let foodId: UUID
    let quantity: Int
}


struct MealFoodResponseDTO: Content {
    let id: UUID
    let foodId: UUID
    let quantity: Int
    let calorie: Int
    let protein: Double
    let carb : Double
    let lipid: Double
    let name: String 
    let icon: String
    let type: String
}

struct MealTotalMacroDTO: Content {
    let calories: Int
    let protein: Double
    let carb: Double
    let lipid: Double
}
