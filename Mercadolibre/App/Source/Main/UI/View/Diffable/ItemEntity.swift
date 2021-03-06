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
    let imageUrl: URL?
    let value: Float
    let installment: Installment?
    let attributes: [ItemAttribute]
    
    var formattedValue: String {
        value.toCurrency()
    }
    
    var formatedInstallment: String? {
        guard let installment = installment else { return nil }
        return "en \(installment.quantity)x \(installment.amount.toCurrency())"
    }
    
    init(id: String = UUID().uuidString, name: String, imageUrl: URL?, value: Float, installment: Installment?,
         attributes: [ItemAttribute] = []) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.value = value
        self.installment = installment
        self.attributes = attributes
    }
    
    override func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ItemEntity, rhs: ItemEntity) -> Bool {
        lhs.id == rhs.id
    }
}
