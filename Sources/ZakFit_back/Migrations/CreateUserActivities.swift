//
//  CreateUserActivities.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 01/12/2025.
//

import Fluent

struct CreateUserActivities: AsyncMigration {
    func prepare(on database: any Database) async throws {
       try await database.schema("user_activities")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("activity_id", .uuid, .required, .references("activities", "id"))
            .field("duration", .int, .required)
            .field("calories", .double)
            .field("date", .date, .required)
            .create()
    }

    func revert(on database: any Database) async throws{
        try await database.schema("user_activities").delete()
    }
}
