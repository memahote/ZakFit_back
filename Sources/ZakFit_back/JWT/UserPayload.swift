//
//  File.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 23/11/2025.
//

import Vapor
import JWT

struct UserPayload : JWTPayload, Authenticatable {
    var id: UUID
    var expiration: Date
    
    func verify(using signer: JWTKit.JWTSigner) throws {
        if self.expiration < Date(){
            throw JWTError.invalidJWK
        }
    }
    
    init(id: UUID) {
        self.id = id
        self.expiration = Date().addingTimeInterval(3600 * 24 * 7)
    }
    
}
