//
//  CreateMealFood.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 29/11/2025.
//

import Fluent

struct CreateMealFood: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("meal_foods")
            .id()
            .field("id_meal", .uuid, .required, .references("meals", "id"))
            .field("id_food", .uuid, .required, .references("foods", "id"))
            .field("quantity", .int, .required)
            .field("calorie", .int, .required)
            .create()
    }

    func revert(on database: any Database) async throws{
        try await database.schema("meal_foods").delete()
    }
}

