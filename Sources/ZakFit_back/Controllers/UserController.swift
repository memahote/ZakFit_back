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
        users.get("all", use: getAllUsers)
        let protected = users.grouped(JWTMiddleware())
        
        protected.patch(use: updateUser)
        protected.get(use: getUser)
        protected.delete(":id", use: deleteUserById)
    }
    
    @Sendable
    func getAllUsers(req: Request) async throws -> [UserResponseDTO] {
        try await User.query(on: req.db).all().map { $0.toDTO() }
    }
    
    @Sendable
    func getUser(req: Request) async throws -> UserResponseDTO {
        let payload = try req.auth.require(UserPayload.self)

        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur introuvable")
        }

        return user.toDTO()
    }
    
    @Sendable
    func createUser(req: Request) async throws -> LoginResponse {
        let user = try req.content.decode(User.self)
        
        if try await User.query(on: req.db).filter(\.$mail == user.mail).first() != nil {
            throw Abort(.badRequest, reason: "mail déjà utilisé")
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
        let signer = JWTSigner.hs256(key: "ZakFit_Go_For_It")
        let token = try signer.sign(payload)
        
        return LoginResponse(token: token)
    }
    
    @Sendable
    func updateUser(req: Request) async throws -> UserResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur introuvable")
        }
        
        let updatedInfo = try req.content.decode(UpdateUserDTO.self)
        
        if let newFirstName = updatedInfo.firstName {
            user.firstName = newFirstName
        }

        if let newLastName = updatedInfo.lastName {
            user.lastName = newLastName
        }

        if let newHeight = updatedInfo.height {
            user.height = newHeight
        }

        if let newBirthDate = updatedInfo.birthDate {
            user.birthDate = newBirthDate
        }

        if let newGender = updatedInfo.gender {
            user.gender = newGender
        }

        if let newDiet = updatedInfo.diet {
            user.diet = newDiet
        }

        if let newPassword = updatedInfo.password {
            user.password = try Bcrypt.hash(newPassword)
        }
        
        try await user.save(on: req.db)
        
        return user.toDTO()
    }
    
    @Sendable
    func deleteUserById(req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "ID invalide")
        }
        
        guard let user = try await User.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur introuvable")
        }

        try await user.delete(on: req.db)
        return .noContent
    }
}
