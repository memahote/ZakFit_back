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
        protected.get("day", use: getMealsOfDay)
        protected.delete(":mealID", use: deleteMeal)
     
        
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
                .with(\.$food)
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

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = formatter.date(from: input.createdAt) {
            meal.createdAt = date
        } else {
            throw Abort(.badRequest, reason: "Invalid date format")
        }

        try await meal.save(on: req.db)
        
        print(meal)

        return MealResponseDTO(
            id: try meal.requireID(),
            type: meal.type,
            createdAt: meal.createdAt,
            foods: []
        )
    }
//    @Sendable
//    func createMeal(req: Request) async throws -> MealResponseDTO {
//        let payload = try req.auth.require(UserPayload.self)
//        let input = try req.content.decode(MealDTO.self)
//
//        let meal = Meal()
//        meal.type = input.type
//        meal.$user.id = payload.id
//        meal.createdAt = input.createdAt
//
//        try await meal.save(on: req.db)
//
//        return MealResponseDTO(
//            id: try meal.requireID(),
//            type: meal.type,
//            createdAt: meal.createdAt,
//            foods: []
//        )
//    }

    func getMealsOfDay(req: Request) async throws -> [MealLightDTO] {
        let user = try req.auth.require(UserPayload.self)

        guard let date = req.query[String.self, at: "date"] else {
            throw Abort(.badRequest, reason: "Missing ?date=YYYY-MM-DD")
        }

        let meals = try await Meal.query(on: req.db)
            .filter(\.$user.$id == user.id)
            .filter(.sql(unsafeRaw: "DATE(created_at) = '\(date)'"))
            .all()

        return meals.map {
            MealLightDTO(
                id: $0.id!,
                type: $0.type,
                createdAt: $0.createdAt
            )
        }
    }

    @Sendable
    func deleteMeal(req: Request) async throws -> HTTPStatus {
        let payload = try req.auth.require(UserPayload.self)

        guard let mealID = req.parameters.get("mealID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Missing meal ID")
        }

        guard let meal = try await Meal.query(on: req.db)
            .filter(\.$id == mealID)
            .filter(\.$user.$id == payload.id)
            .first()
        else {
            throw Abort(.notFound, reason: "Meal not found or doesn't belong to user")
        }

        let mealFoods = try await MealFood.query(on: req.db)
            .filter(\.$meal.$id == mealID)
            .all()

        for mf in mealFoods {
            try await mf.delete(on: req.db)
        }

        try await meal.delete(on: req.db)

        return .noContent
    }

}
