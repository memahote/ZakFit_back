//
//  AddTypeToFood.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 29/11/2025.
//

import Fluent

struct AddTypeToFood: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("foods")
            .field("type", .string, .required)
            .update()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("foods")
            .deleteField("type")
            .update()
    }
}
