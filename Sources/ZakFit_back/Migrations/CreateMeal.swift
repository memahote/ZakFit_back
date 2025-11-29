//
//  CreateMeal.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 29/11/2025.
//

import Fluent

struct CreateMeal: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("meals")
            .id()
            .field("type", .string, .required)
            .field("created_at", .datetime)
            .field("user_id", .uuid, .required, .references("users", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("meals").delete()
    }
}

