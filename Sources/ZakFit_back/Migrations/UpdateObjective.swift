//
//  UpdateObjective.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 26/11/2025.
//

import Fluent

struct UpdateObjective: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("objectives")
            .updateField("training_duration_goal", .int)
            .updateField("calorie_burned_goal", .int)
            .update()
    }

    func revert(on db: any Database) async throws {
        try await db.schema("objectives")
            .field("training_duration_goal", .int, .required)
            .field("calorie_burned_goal", .int, .required)
            .update()
    }
}

