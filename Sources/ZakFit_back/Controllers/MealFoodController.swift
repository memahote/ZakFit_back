//
//  MealFoodController.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 29/11/2025.
//

import Fluent
import Vapor
import JWT

struct MealFoodController: RouteCollection{
    func boot(routes: any RoutesBuilder) throws {
        let mealFoods = routes.grouped("meal_foods")
        
        let protected = mealFoods.grouped(JWTMiddleware())
        
        protected.post(":mealId", use: addFoodToMeal)
        protected.delete(":id", use: deleteFoodFromMeal)
        protected.get(":mealId", use: getMealFoods)
        protected.get("total", ":mealId", use: getMealTotals)
        protected.get("calories", use: getWeeklyConsumedCalories)

        
    }
    
    @Sendable
    func addFoodToMeal(req: Request) async throws -> MealFoodResponseDTO {
        try req.auth.require(UserPayload.self)
        
        guard let mealId = req.parameters.get("mealId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Missing mealId")
        }
        
        let input = try req.content.decode(MealFoodDTO.self)
        
        guard input.quantity > 0 else {
            throw Abort(.badRequest, reason: "Quantity must be greater than 0")
        }
        
        guard let _ = try await Meal.find(mealId, on: req.db) else {
            throw Abort(.notFound, reason: "Meal not found")
        }
        
        guard let food = try await Food.find(input.foodId, on: req.db) else {
            throw Abort(.notFound, reason: "Food not found")
        }
        
        let mealFood = MealFood()
        mealFood.$meal.id = mealId
        mealFood.$food.id = input.foodId
        mealFood.quantity = input.quantity
        mealFood.calorie = Int(Double(food.calorie) * (Double(input.quantity) / 100.0))
        mealFood.protein = food.protein * (Double(input.quantity) / 100.0)
        mealFood.carb = food.carb * (Double(input.quantity) / 100.0)
        mealFood.lipid = food.lipid * (Double(input.quantity) / 100.0)
        
        try await mealFood.save(on: req.db)
        
        try await mealFood.$food.load(on: req.db)
        
        return mealFood.toDTO()
    }
    
    @Sendable
    func deleteFoodFromMeal(req: Request) async throws -> HTTPStatus {
        try req.auth.require(UserPayload.self)
        
        guard let id = req.parameters.get("id", as: UUID.self),
              let food = try await MealFood.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await food.delete(on: req.db)
        return .noContent
    }
    
    @Sendable
    func getMealFoods(req: Request) async throws -> [MealFoodResponseDTO] {
        try req.auth.require(UserPayload.self)
        
        guard let mealId = req.parameters.get("mealId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Missing mealId")
        }
        
        guard let _ = try await Meal.find(mealId, on: req.db) else {
            throw Abort(.notFound, reason: "Meal not found")
        }
        
        let mealFoods = try await MealFood.query(on: req.db)
            .filter(\.$meal.$id == mealId)
            .with(\.$food)
            .all()
        
        return mealFoods.map { $0.toDTO() }
    }
    
    
    @Sendable
    func getMealTotals(req: Request) async throws -> MealTotalMacroDTO {
        try req.auth.require(UserPayload.self)
        
        guard let mealId = req.parameters.get("mealId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Missing mealId")
        }
        
        let mealFoods = try await MealFood.query(on: req.db)
            .filter(\.$meal.$id == mealId)
            .all()
        
        let totalCalories = mealFoods.reduce(0) { $0 + $1.calorie }
        let totalProtein  = mealFoods.reduce(0) { $0 + $1.protein }
        let totalCarb     = mealFoods.reduce(0) { $0 + $1.carb }
        let totalLipid    = mealFoods.reduce(0) { $0 + $1.lipid }
        
        return MealTotalMacroDTO(
            calories: totalCalories,
            protein: totalProtein,
            carb: totalCarb,
            lipid: totalLipid
        )
    }
    
    func getWeeklyConsumedCalories(req: Request) async throws -> WeeklyCaloriesDTO {
        let payload = try req.auth.require(UserPayload.self)
        let calendar = Calendar(identifier: .iso8601)
        let now = Date()

        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: now) else {
            throw Abort(.internalServerError, reason: "Cannot compute week interval")
        }

        let meals = try await Meal.query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .filter(\.$createdAt >= weekInterval.start)
            .filter(\.$createdAt < weekInterval.end)
            .all()

        let mealIds = meals.compactMap { $0.id }

        let mealFoods = try await MealFood.query(on: req.db)
            .filter(\.$meal.$id ~~ mealIds)
            .all()

        var dailyCalories: [String: Int] = [
            "monday": 0, "tuesday": 0, "wednesday": 0,
            "thursday": 0, "friday": 0, "saturday": 0, "sunday": 0
        ]

        for meal in meals {
            let day = calendar.component(.weekday, from: meal.createdAt ?? now)
            let mealId = meal.id!

            let totalCalories = mealFoods
                .filter { $0.$meal.id == mealId }
                .reduce(0) { $0 + $1.calorie }

            let key: String
            switch day {
            case 2: key = "monday"
            case 3: key = "tuesday"
            case 4: key = "wednesday"
            case 5: key = "thursday"
            case 6: key = "friday"
            case 7: key = "saturday"
            case 1: key = "sunday"
            default: continue
            }

            dailyCalories[key, default: 0] += totalCalories
        }

        return WeeklyCaloriesDTO(days: dailyCalories)
    }

    
}
