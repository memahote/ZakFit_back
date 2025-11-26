//
//  ObjectiveController.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 26/11/2025.
//

import Fluent
import Vapor
import JWT

struct ObjectiveController: RouteCollection{
    func boot(routes: any RoutesBuilder) throws {
        let objectives = routes.grouped("objectives")
        
        let protected = objectives.grouped(JWTMiddleware())
        
        protected.post(use: createObjective)
        
    }
    
    @Sendable
    func createObjective(req: Request) async throws -> ObjectiveResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        let clientInput = try req.content.decode(CreateObjectiveDTO.self)
        let objectives = Objective(userID: payload.id, goal: clientInput.goal, weightGoal: clientInput.weightGoal, dailyCalorieGoal: clientInput.dailyCalorieGoal, numberTrainingGoal: clientInput.numberTrainingGoal)
        
        try await objectives.save(on: req.db)
        
        return objectives.toDTO()
    }
    
}
