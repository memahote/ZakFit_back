//
//  ObjectiveDTO.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 26/11/2025.
//

import Fluent
import Vapor


struct CreateObjectiveDTO: Content {
    let goal: String
    let weightGoal: Double
    let dailyCalorieGoal: Int
    let numberTrainingGoal: Int
}

struct ObjectiveResponseDTO: Content {
    let id: UUID
    let goal: String
    let weightGoal: Double
    let dailyCalorieGoal: Int
    let numberTrainingGoal: Int
}

struct UpdateObjectiveDTO: Content {
    let goal: String?
    let weightGoal: Double?
    let dailyCalorieGoal: Int?
    let numberTrainingGoal: Int?
    let trainingDurationGoal : Int?
    let calorieBurnedGoal: Int?
}

struct ObjectiveFullResponseDTO: Content {
    let id: UUID
    let goal: String
    let weightGoal: Double
    let dailyCalorieGoal: Int
    let numberTrainingGoal: Int
    let trainingDurationGoal : Int
    let calorieBurnedGoal: Int
}
