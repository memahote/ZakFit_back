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
    
    @Field(key: "goal")
    var goal: String
    
    @Field(key: "weight_goal")
    var weightGoal: Double
    
    @Field(key: "daily_calorie_goal")
    var dailyCalorieGoal: Int
    
    @Field(key: "number_training_goal")
    var numberTrainingGoal: Int
    
    @Field(key: "training_duration_goal")
    var trainingDurationGoal: Int?
    
    @Field(key: "calorie_burned_goal")
    var calorieBurnedGoal: Int?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Parent(key: "user_id")
    var user: User
    
    init() { }
    
    init(userID: UUID, goal: String, weightGoal: Double, dailyCalorieGoal: Int, numberTrainingGoal: Int) {
        self.$user.id = userID
        self.goal = goal
        self.weightGoal = weightGoal
        self.dailyCalorieGoal = dailyCalorieGoal
        self.numberTrainingGoal = numberTrainingGoal
    }

   
    func toDTO() -> ObjectiveResponseDTO {
        ObjectiveResponseDTO(
            id: id ?? UUID(),
            goal: goal,
            weightGoal: weightGoal,
            dailyCalorieGoal: dailyCalorieGoal,
            numberTrainingGoal: numberTrainingGoal
        )
    }
    
    func toFullDTO() -> ObjectiveFullResponseDTO{
        ObjectiveFullResponseDTO(
            id: id ?? UUID(),
            goal: goal,
            weightGoal: weightGoal,
            dailyCalorieGoal: dailyCalorieGoal,
            numberTrainingGoal: numberTrainingGoal,
            trainingDurationGoal: trainingDurationGoal ?? 0,
            calorieBurnedGoal: calorieBurnedGoal ?? 0)
    }
}
