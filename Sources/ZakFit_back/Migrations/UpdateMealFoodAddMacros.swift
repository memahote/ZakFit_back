//
//  UpdateMealFoodAddMacros.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 30/11/2025.
//

import Fluent

struct UpdateMealFoodAddMacros: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("meal_foods")
            .field("protein", .double, .required)
            .field("carb", .double, .required)
            .field("lipid", .double, .required)
            .update()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("meal_foods")
            .deleteField("protein")
            .deleteField("carb")
            .deleteField("lipid")
            .update()
    }
}
