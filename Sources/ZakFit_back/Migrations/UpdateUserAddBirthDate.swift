//
//  ChangeAgeUser.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 26/11/2025.
//

import Fluent

struct UpdateUserAddBirthDate: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("users")
            .deleteField("age")
            .field("birth_date", .date)
            .update()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("users")
            .field("age", .int)
            .deleteField("birth_date")
            .update()
    }
}
