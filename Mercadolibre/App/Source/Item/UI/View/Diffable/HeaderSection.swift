//
//  HeaderSection.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 5/03/21.
//

import Foundation

/// Defines shared protocol for Entities displayed on Item View
class MainItemDetailSection: Hashable {
    let uuid = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: MainItemDetailSection, rhs: MainItemDetailSection) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

/// Entity defines an error occured during execution
final class MainItemDetailErrorSection: MainItemDetailSection {
    let errorMessage: String
    
    init(errorMessage: String) {
        self.errorMessage = errorMessage
    }
}

/// Loading item skeleton
final class MainItemDetailLoadingSection: MainItemDetailSection { }
