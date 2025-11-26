//
//  Weight.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 26/11/2025.
//

import Fluent
import Vapor

final class Weight: Model, @unchecked Sendable {
    static let schema = "weights"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "weight")
    var weight: Double
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Parent(key: "user_id")
    var user: User
    
    init() { }
    
    init(userID: UUID, weight: Double) {
        self.weight = weight
        self.$user.id = userID
    }
    
    func toDTO() -> WeightResponseDTO {
        WeightResponseDTO(
            id: id!,
            weight: weight,
            date: createdAt!.formattedDate()
        )
    }
}
