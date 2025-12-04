//
//  NutritionController.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 04/12/2025.
//

import Vapor
import Fluent

struct NutritionController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let nutrition = routes.grouped("nutrition").grouped(JWTMiddleware())
        nutrition.get("day-summary", use: getDaySummary)
    }
    
    @Sendable
    func getDaySummary(req: Request) async throws -> DaySummaryDTO {
        let user = try req.auth.require(UserPayload.self)
        
        guard let date = req.query[String.self, at: "date"] else {
            throw Abort(.badRequest, reason: "Missing ?date=YYYY-MM-DD")
        }
        
        let meals = try await Meal.query(on: req.db)
            .filter(\.$user.$id == user.id)
            .filter(.sql(unsafeRaw: "DATE(created_at) = '\(date)'"))
            .all()
        
        var totalCalories = 0
        var totalProtein  = 0.0
        var totalCarb     = 0.0
        var totalLipid    = 0.0
        
        var mealSummaries: [MealSummaryDTO] = []
        
        for meal in meals {
            let mealFoods = try await MealFood.query(on: req.db)
                .filter(\.$meal.$id == meal.id!)
                .all()
            
            let mealCalories = mealFoods.reduce(0) { $0 + $1.calorie }
            
            mealSummaries.append(
                MealSummaryDTO(
                    id: meal.id!,
                    type: meal.type,
                    createdAt: meal.createdAt,
                    totalKcal: mealCalories
                )
            )
            
            totalCalories += mealCalories
            totalProtein  += mealFoods.reduce(0) { $0 + $1.protein }
            totalCarb     += mealFoods.reduce(0) { $0 + $1.carb }
            totalLipid    += mealFoods.reduce(0) { $0 + $1.lipid }
        }
        
        return DaySummaryDTO(
            calories: totalCalories,
            protein: totalProtein,
            carb: totalCarb,
            lipid: totalLipid,
            meals: mealSummaries
        )
    }
}
