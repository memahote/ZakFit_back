//
//  FoodController.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 28/11/2025.
//

import Fluent
import Vapor
import JWT

struct FoodController: RouteCollection{
    func boot(routes: any RoutesBuilder) throws {
        let foods = routes.grouped("foods")
        
        let protected = foods.grouped(JWTMiddleware())
        
        protected.get("all", use: getAllFoods)
        protected.post(use: addFood)
        protected.delete(":id", use: deleteFood)
        protected.get(":type", use: getFoodByType)
        
    }
    
    @Sendable
    func getAllFoods(req :Request) async throws -> [FoodResponseDTO]{
        try req.auth.require(UserPayload.self)
        
        return try await Food.query(on: req.db).all().map{ $0.toDTO()}
    }
    
    @Sendable
    func getFoodByType(req: Request) async throws -> [FoodResponseDTO]{
        try req.auth.require(UserPayload.self)
        
        guard let mealType = req.parameters.get("type", as: String.self) else {
            throw Abort(.badRequest, reason: "Missing type of meal")
        }
        
        let filteredFood = try await Food.query(on: req.db)
            .filter(\.$type == mealType)
            .all()
        
        return filteredFood.map { $0.toDTO()}
    }
    
    @Sendable
    func addFood(req: Request) async throws -> FoodResponseDTO {
        try req.auth.require(UserPayload.self)
        
        let clientInput = try req.content.decode(FoodDTO.self).toModel()
        
        try await clientInput.save(on: req.db)
        
        return clientInput.toDTO()
    }
    
    @Sendable
    func deleteFood(req: Request) async throws -> HTTPStatus {
        try req.auth.require(UserPayload.self)

        guard let id = req.parameters.get("id", as: UUID.self),
              let food = try await Food.find(id, on: req.db)
        else { throw Abort(.notFound) }

        try await food.delete(on: req.db)
        return .noContent
    }
    
}
