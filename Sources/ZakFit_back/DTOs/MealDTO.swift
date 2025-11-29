//
//  MealDTO.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 29/11/2025.
//

import Fluent
import Vapor

struct MealDTO: Content {
    let type: String
    let foods: [MealFoodDTO]
}


struct MealResponseDTO: Content {
    let id: UUID
    let type: String
    let createdAt: Date?
    let foods: [MealFoodResponseDTO]
}

