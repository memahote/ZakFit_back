//
//  UserActivity.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 01/12/2025.
//

import Fluent
import Vapor

final class UserActivity: Model, @unchecked Sendable {
    static let schema = "user_activities"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Parent(key: "activity_id")
    var activity: Activity

    @Field(key: "duration")
    var duration: Int

    @Field(key: "calories")
    var calories: Double?

    @Field(key: "date")
    var date: Date
    
    init() { }
    
    func toDTO(activity: Activity) throws -> UserActivityResponseDTO {
            return UserActivityResponseDTO(
                id: try self.requireID(),
                activity: activity.toDTO(),
                duration: self.duration,
                calories: self.calories,
                date: self.date
            )
        }
}
