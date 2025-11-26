//
//  ObjectiveDTO.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 26/11/2025.
//

import Fluent
import Vapor


struct ObjectiveResponseDTO: Content {
    let weight: Double
    let dailyCalorieGoal: Int
    let numberTrainingGoal: Int
    let trainingDurationGoal: Int
    let calorieBurnedGoal: Int
    let createdAt: Date
}
