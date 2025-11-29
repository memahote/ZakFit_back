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
}

