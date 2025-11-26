//
//  CreateWeight.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 26/11/2025.
//

import Fluent

struct CreateWeight: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("weights")
            .id()
            .field("weight", .double, .required)
            .field("created_at", .datetime)
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("users").delete()
    }
}
