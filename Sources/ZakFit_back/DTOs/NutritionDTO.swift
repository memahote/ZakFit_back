//
//  NutritionDTO.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 04/12/2025.
//

import Foundation
import Vapor

struct DaySummaryDTO: Content {
    let calories: Int
    let protein: Double
    let carb: Double
    let lipid: Double
    let meals: [MealSummaryDTO]
}

struct MealSummaryDTO: Content {
    let id: UUID
    let type: String
    let createdAt: Date?
    let totalKcal: Int
}
