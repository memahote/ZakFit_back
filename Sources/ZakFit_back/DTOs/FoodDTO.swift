//
//  FoodDTO.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 29/11/2025.
//

import Fluent
import Vapor

struct FoodDTO: Content {
    let name : String
    let type: String
    let protein: Double
    let carb: Double
    let lipid: Double
    let calorie: Double
    let icon : String
    
    func toModel() -> Food {
        let model = Food()
        
        model.name = self.name
        model.type = self.type
        model.protein = self.protein
        model.carb = self.carb
        model.lipid = self.lipid
        model.calorie = self.calorie
        model.icon = self.icon
        
        return model
    }
}

struct FoodResponseDTO : Content {
    let id: UUID
    let name : String
    let type: String
    let protein: Double
    let carb: Double
    let lipid: Double
    let calorie: Double
    let icon : String
}
