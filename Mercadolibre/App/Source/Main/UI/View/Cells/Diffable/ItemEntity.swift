//
//  ItemEntity.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 20/02/21.
//

import Foundation

/// Entity that represents an item
class ItemEntity: MainItemEntity {
    let id: String
    let name: String
    let imageUrl: String
    let value: Float
    
    var formattedValue: String {
        "$ \(value)"
    }
    
    init(id: String = UUID().uuidString, name: String, imageUrl: String, value: Float) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.value = value
    }
    
    override func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ItemEntity, rhs: ItemEntity) -> Bool {
        lhs.id == rhs.id
    }
}
