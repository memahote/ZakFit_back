//
//  File.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 23/11/2025.
//

import Vapor

struct LoginRequest : Content {
    let mail : String
    let password : String
}


struct LoginResponse: Content {
    let token: String
}
