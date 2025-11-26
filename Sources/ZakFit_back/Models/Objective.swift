//
//  Objective.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 26/11/2025.
//

import Fluent
import Vapor

final class Objective: Model, @unchecked Sendable {
    static let schema = "objectives"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "weight_goal")
    var weight: Double
    
    @Field(key: "daily_calorie_goal")
    var dailyCalorieGoal: Int
    
    @Field(key: "number_training_goal")
    var numberTrainingGoal: Int
    
    @Field(key: "training_duration_goal")
    var trainingDurationGoal: Int
    
    @Field(key: "calorie_burned_goal")
    var calorieBurnedGoal: Int
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Parent(key: "user_id")
    var user: User
    
    init() { }
    
    init(userID: UUID, weight: Double, dailyCalorieGoal: Int, numberTrainingGoal: Int, trainingDurationGoal: Int, calorieBurnedGoal: Int) {
        self.$user.id = userID
        self.weight = weight
        self.dailyCalorieGoal = dailyCalorieGoal
        self.numberTrainingGoal = numberTrainingGoal
        self.trainingDurationGoal = trainingDurationGoal
        self.calorieBurnedGoal = calorieBurnedGoal
    }
   
    func toDTo() -> ObjectiveResponseDTO{
        ObjectiveResponseDTO(weight: weight, dailyCalorieGoal: dailyCalorieGoal, numberTrainingGoal: numberTrainingGoal, trainingDurationGoal: trainingDurationGoal, calorieBurnedGoal: calorieBurnedGoal, createdAt: createdAt ?? Date())
    }
}
