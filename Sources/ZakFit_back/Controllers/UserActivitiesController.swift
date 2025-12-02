//
//  UserActivitiesController.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 01/12/2025.
//

import Fluent
import Vapor
import JWT

struct UserActivitiesController: RouteCollection{
    func boot(routes: any RoutesBuilder) throws {
        let user_activities = routes.grouped("user_activities")
        
        let protected = user_activities.grouped(JWTMiddleware())
        
        protected.post(use: addActivityToUser)
        protected.get("all", use: getAllUserActivities)
        protected.delete(":activityId", use: deleteUserActivity)
        
        
    }
    
    @Sendable
    func addActivityToUser(req: Request) async throws -> UserActivityResponseDTO {
        try req.auth.require(UserPayload.self)
        
        let input = try req.content.decode(UserActivityDTO.self).toModel()
        
        guard let activity = try await Activity.find(input.activity.id, on: req.db) else {
            throw Abort(.notFound, reason: "Activity not found")
        }
        
        try await input.save(on: req.db)
        
        return try input.toDTO(activity: activity)
    }
    
    func getAllUserActivities(req: Request) async throws -> [UserActivityResponseDTO] {
        let payload = try req.auth.require(UserPayload.self)
        
        let activities = try await UserActivity.query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .with(\.$activity)
            .all()
        
        return try activities.map { try $0.toDTO(activity: $0.activity) }
    }
    
    func deleteUserActivity(req: Request) async throws -> HTTPStatus {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let id = req.parameters.get("activityId", as: UUID.self),
              let userActivity = try await UserActivity.find(id, on: req.db),
              userActivity.$user.id == payload.id else {
            throw Abort(.notFound, reason: "UserActivity not found")
        }
        
        try await userActivity.delete(on: req.db)
        return .noContent
    }
}
