//
//  PoketmonModel.swift
//  PoketmonProfile
//
//  Created by 전성진 on 7/11/24.
//

struct Sprites: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct Pokemon: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
}
