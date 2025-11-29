//
//  UpdateFoodIntToDouble.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 29/11/2025.
//

import Fluent

struct UpdateFoodIntToDouble: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("foods")
            .updateField("protein", .double)
            .updateField("carb", .double)
            .updateField("lipid", .double)
            .updateField("calorie", .double)
            .update()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("foods")
            .updateField("protein", .int)
            .updateField("carb", .int)
            .updateField("lipid", .int)
            .updateField("calorie", .int)
            .update()
    }
}
