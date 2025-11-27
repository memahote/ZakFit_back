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
        protected.patch(use: updateObjective)
        protected.get(use: getObjectiveByUserid)
        
    }
    
    @Sendable
    func createObjective(req: Request) async throws -> ObjectiveResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        let clientInput = try req.content.decode(CreateObjectiveDTO.self)
        let objectives = Objective(userID: payload.id, goal: clientInput.goal, weightGoal: clientInput.weightGoal, dailyCalorieGoal: clientInput.dailyCalorieGoal, numberTrainingGoal: clientInput.numberTrainingGoal)
        
        try await objectives.save(on: req.db)
        
        return objectives.toDTO()
    }
    
    @Sendable
    func updateObjective(req: Request) async throws -> ObjectiveFullResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let objective = try await Objective
            .query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .first()
        else {
            throw Abort(.notFound, reason: "Aucun objectif trouvé pour cet utilisateur.")
        }
        
        let updateData = try req.content.decode(UpdateObjectiveDTO.self)
        
        if let goal = updateData.goal {
            objective.goal = goal
        }
        if let weightGoal = updateData.weightGoal {
            objective.weightGoal = weightGoal
        }
        if let dailyCalorieGoal = updateData.dailyCalorieGoal {
            objective.dailyCalorieGoal = dailyCalorieGoal
        }
        if let numberTrainingGoal = updateData.numberTrainingGoal {
            objective.numberTrainingGoal = numberTrainingGoal
        }
        if let trainingDurationGoal = updateData.trainingDurationGoal {
            objective.trainingDurationGoal = trainingDurationGoal
        }
        if let calorieBurnedGoal = updateData.calorieBurnedGoal {
            objective.calorieBurnedGoal = calorieBurnedGoal
        }
        
        try await objective.save(on: req.db)
        
        return objective.toFullDTO()
        
        
    }
    
    @Sendable
    func getObjectiveByUserid(req: Request) async throws -> ObjectiveFullResponseDTO {
        let payload = try req.auth.require(UserPayload.self)

        guard let objective = try await Objective
            .query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .first()
        else {
            throw Abort(.notFound, reason: "Aucun objectif trouvé pour cet utilisateur.")
        }
        
        
        return objective.toFullDTO()
    }
}
