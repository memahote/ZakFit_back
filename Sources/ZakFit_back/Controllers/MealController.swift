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

}
