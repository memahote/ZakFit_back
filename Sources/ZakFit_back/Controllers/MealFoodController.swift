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
        
     
        
    }
    

}
