//
//  ItemDetailPrice.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 6/03/21.
//

import Foundation

/// Price section
final class ItemDetailPrice: MainItemDetailSection {
    let price: Float
    let original: Float?
    let discount: Int?
    let installments: Installment
    
    init(price: Float, original: Float?, discount: Int?, installments: Installment) {
        self.price = price
        self.original = original
        self.discount = discount
        self.installments = installments
    }
}


