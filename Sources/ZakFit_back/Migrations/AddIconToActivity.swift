//
//  AddIconToActivity.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 02/12/2025.
//

import Fluent


struct AddIconToActivity: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("activities")
            .field("icon", .string, .required)
            .update()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("activities")
            .deleteField("icon")
            .update()
    }
}
