//
//  CreateUser.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 23/11/2025.
//

import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("users")
            .id()
            .field("last_name", .string, .required)
            .field("first_name", .string, .required)
            .field("mail", .string, .required)
            .field("password", .string, .required)
            .field("height", .int)
            .field("age", .int)
            .field("gender", .string)
            .field("diet", .string)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .unique(on: "mail")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("users").delete()
    }
}
