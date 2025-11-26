//
//  CreateObjective.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 26/11/2025.
//

import Fluent

struct CreateObjective: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("objectives")
            .id()
            .field("goal", .string, .required)
            .field("weight_goal", .double, .required)
            .field("daily_calorie_goal", .int, .required)
            .field("number_training_goal", .int, .required)
            .field("training_duration_goal", .int, .required)
            .field("calorie_burned_goal", .int, .required)
            .field("created_at", .datetime)
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("objectives").delete()
    }
}

