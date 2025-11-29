//
//  CreateFood.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 29/11/2025.
//

import Fluent

struct CreateFood: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("foods")
            .id()
            .field("name", .string, .required)
            .field("protein", .int, .required)
            .field("carb", .int, .required)
            .field("lipid", .int, .required)
            .field("calorie", .int, .required)
            .field("icon", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("foods").delete()
    }
}
