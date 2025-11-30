//
//  Activity.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 01/12/2025.
//

import Fluent
import Vapor

final class Activity: Model, @unchecked Sendable {
    static let schema = "activity"
    
    @ID(key: .id)
    var id: UUID?
    
    
    
    @Parent(key: "user_id")
    var user: User
    
    init() {
        
    }
    

    
}
