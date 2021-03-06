//
//  ItemDetailSection.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 5/03/21.
//

import Foundation

final class ItemDetailSection: Hashable {
    var id = UUID()
    var title: String
    var items: [MainItemDetailSection]
    
    init(title: String, items: [MainItemDetailSection]) {
        self.title = title
        self.items = items
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ItemDetailSection, rhs: ItemDetailSection) -> Bool {
        lhs.id == rhs.id
    }
}
