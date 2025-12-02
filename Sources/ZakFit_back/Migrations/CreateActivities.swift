//
//  CreateActivities.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 01/12/2025.
//

import Fluent

struct CreateActivities: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("activities")
            .id()
            .field("category", .string, .required)
            .field("name", .string, .required)
            .field("calories_per_min", .double, .required)
            .create()
    }

    func revert(on database: any Database)async throws {
        try await database.schema("activities").delete()
    }
}

