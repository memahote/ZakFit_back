//
//  ActivityDTO.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 01/12/2025.
//

import Fluent
import Vapor

struct ActivityDTO: Content {
    let category: String
    let name: String
    let caloriesPerMin : Double
    let icon : String
    
    func toModel() -> Activity {
        let model = Activity()
        
        model.category = self.category
        model.name = self.name
        model.caloriesPerMin = self.caloriesPerMin
        model.icon = self.icon
        
        return model
    }
}

struct ActivityResponseDTO: Content {
    let id : UUID
    let category: String
    let name: String
    let caloriesPerMin : Double
    let icon : String
}


