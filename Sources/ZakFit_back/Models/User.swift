//
//  File.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 23/11/2025.
//

import Fluent
import Vapor

final class User: Model, @unchecked Sendable, Authenticatable{
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "last_name")
    var lastName: String
    
    @Field(key: "first_name")
    var firstName: String
    
    @Field(key: "mail")
    var mail: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "height")
    var height: Int?
    
    @Field(key: "age")
    var age: Int?
    
    @Field(key: "gender")
    var gender: String?
    
    @Field(key: "diet")
    var diet: String?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() { }
    
   
}
