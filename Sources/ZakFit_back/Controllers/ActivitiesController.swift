//
//  ActivitiesController.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 01/12/2025.
//

import Fluent
import Vapor
import JWT

struct ActivitiesController: RouteCollection{
    func boot(routes: any RoutesBuilder) throws {
        let activities = routes.grouped("activities")
        
        let protected = activities.grouped(JWTMiddleware())
        
        protected.post(use: createActivity)
        protected.get("all", use: getAllActivity)
        protected.delete(":activityID",use: deleteActivity)
        
    }
    
    @Sendable
    func createActivity(req: Request) async throws -> ActivityResponseDTO {
        try req.auth.require(UserPayload.self)
        
        let input = try req.content.decode(ActivityDTO.self).toModel()
        
        try await input.save(on: req.db)
        
        return input.toDTO()
    }
    
    func getAllActivity(req: Request) async throws -> [ActivityResponseDTO] {
        try req.auth.require(UserPayload.self)
        return try await Activity.query(on: req.db).all().map { $0.toDTO() }
    }
    
    func deleteActivity(req: Request) async throws -> HTTPStatus {
        try req.auth.require(UserPayload.self)
        
        guard let id = req.parameters.get("activityID", as: UUID.self),
              let activity = try await Activity.find(id, on: req.db)
        else {
            throw Abort(.notFound, reason: "Activity not found")
        }
        
        try await activity.delete(on: req.db)
        return .noContent
    }
}
