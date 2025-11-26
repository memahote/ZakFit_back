//
//  UserDTO.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 26/11/2025.
//

import Fluent
import Vapor


struct UserResponseDTO: Content {
    let id: UUID
    let firstName: String
    let lastName: String
    let height: Int?
    let birthDate: Date?
    let gender: String?
    let diet: String?
    let createdAt: Date?
}


struct UpdateUserDTO: Content {
    var firstName: String?
    var lastName: String?
    var height: Int?
    var birthDate: Date?
    var gender: String?
    var diet: String?
    var password: String?
}


