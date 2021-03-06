//
//  ItemDetailHeader.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 5/03/21.
//

import Foundation

/// Header section
final class ItemDetailHeader: MainItemDetailSection {
    let name: String
    let condition: String?
    let soldQuantity: Int?
    let soldBy: String?
    
    init(name: String, condition: String?, soldQuantity: Int?, soldBy: String?) {
        self.name = name
        self.condition = condition
        self.soldQuantity = soldQuantity
        self.soldBy = soldBy
    }
}
