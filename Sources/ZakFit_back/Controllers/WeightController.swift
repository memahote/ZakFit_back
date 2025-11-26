//
//  WeightController.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 26/11/2025.
//

import Fluent
import Vapor
import JWT

struct WeightController: RouteCollection{
    func boot(routes: any RoutesBuilder) throws {
        let weights = routes.grouped("weights")
        
        let protected = weights.grouped(JWTMiddleware())
        
        protected.post(use: createWeight)
        
        
    }
    
    @Sendable
    func createWeight(req: Request) async throws -> WeightResponseDTO{
        let payload = try req.auth.require(UserPayload.self)

        let clientInput = try req.content.decode(CreateWeightDTO.self)
        let weight = Weight(userID: payload.id, weight: clientInput.weight)
        
        try await weight.save(on: req.db)
        
        return weight.toDTO()
    }
    
    
}
