//
//  File.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 23/11/2025.
//

import Fluent
import Vapor
import JWT

struct UserController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")
        
        users.post("register", use: createUser)
        users.post("login", use: login)
     
    }
    
    @Sendable
    func createUser(req: Request) async throws -> LoginResponse {
        let user = try req.content.decode(User.self)
        
        if try await User.query(on: req.db).filter(\.$mail == user.mail).first() != nil {
            throw Abort(.badRequest, reason: "Username déjà utilisé")
        }
        
        user.password = try Bcrypt.hash(user.password)
        try await user.save(on: req.db)
        
        let payload = UserPayload(id: user.id!)
        let signer = JWTSigner.hs256(key: "ZakFit_Go_For_It")
        let token = try signer.sign(payload)
        
        return LoginResponse(token: token)
        
    }
    
    @Sendable
    func login(req: Request) async throws -> LoginResponse {
        let loginRequest = try req.content.decode(LoginRequest.self)
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$mail == loginRequest.mail)
            .first() else {
            throw Abort(.unauthorized, reason: "Utilisateur introuvable")
        }
        
        guard try Bcrypt.verify(loginRequest.password, created: user.password) else {
            throw Abort(.unauthorized, reason: "Mot de passe incorrect")
        }
        
        let payload = UserPayload(id: try user.requireID())
        let signer = JWTSigner.hs256(key: "my_paw")
        let token = try signer.sign(payload)
        
        return LoginResponse(token: token)
    }
    
}
