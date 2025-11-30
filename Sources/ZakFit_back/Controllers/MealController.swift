//
//  MealController.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 29/11/2025.
//

import Fluent
import Vapor
import JWT

struct MealController: RouteCollection{
    func boot(routes: any RoutesBuilder) throws {
        let meals = routes.grouped("meals")
        
        let protected = meals.grouped(JWTMiddleware())
        protected.post(use: createMeal)
        protected.get("all", use: getMeals)

     
        
    }
    
    @Sendable
    func getMeals(req: Request) async throws -> [MealResponseDTO] {
        try req.auth.require(UserPayload.self)

        let meals = try await Meal.query(on: req.db)
            .with(\.$foods)
            .all()

        var result: [MealResponseDTO] = []

        for meal in meals {
            let mealFoods = try await MealFood.query(on: req.db)
                .filter(\.$meal.$id == meal.id!)
                .all()
            
            let foodsDTO = mealFoods.map { $0.toDTO() }
            
            result.append(meal.toDTO(foods: foodsDTO))
        }

        return result
    }

    @Sendable
    func createMeal(req: Request) async throws -> MealResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        let input = try req.content.decode(MealDTO.self)

        let meal = Meal()
        meal.type = input.type
        meal.$user.id = payload.id

        try await meal.save(on: req.db)

        return MealResponseDTO(
            id: try meal.requireID(),
            type: meal.type,
            createdAt: meal.createdAt,
            foods: []
        )
    }


}
