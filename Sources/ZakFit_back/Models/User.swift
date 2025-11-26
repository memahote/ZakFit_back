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
    
    @Field(key: "birth_date")
    var birthDate: Date?
    
    @Field(key: "gender")
    var gender: String?
    
    @Field(key: "diet")
    var diet: String?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() { }
    
    func toDTO() -> UserResponseDTO {
            UserResponseDTO(
                id: id!,
                firstName: firstName,
                lastName: lastName,
                height: height,
                birthDate: birthDate,
                gender: gender,
                diet: diet,
                createdAt: createdAt
            )
        }
   
}


