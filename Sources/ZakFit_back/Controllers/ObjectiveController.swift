//
//  ObjectiveController.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 26/11/2025.
//

import Fluent
import Vapor
import JWT

struct ObjectiveController: RouteCollection{
    func boot(routes: any RoutesBuilder) throws {
        let objectives = routes.grouped("objectives")
        
        let protected = objectives.grouped(JWTMiddleware())
        
            
        
    }
    
    
    
}
