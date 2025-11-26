//
//  WeightDTO.swift
//  ZakFit_back
//
//  Created by Mounir Emahoten on 26/11/2025.
//

import Fluent
import Vapor

struct CreateWeightDTO: Content {
    let weight: Double

}

struct WeightResponseDTO: Content {
    var id: UUID
    var weight: Double
    var date: String
}
