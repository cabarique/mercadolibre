//
//  MainItemEntity.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 23/02/21.
//

import Foundation

/// Defines shared protocol for Entities displayed on Main View
class MainItemEntity: Hashable {
    let uuid = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: MainItemEntity, rhs: MainItemEntity) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

/// Entity defines an error occured during execution
final class ItemErrorEntity: MainItemEntity {
    let errorMsg: String
    
    init(errorMsg: String) {
        self.errorMsg = errorMsg
    }
}

/// Loading item skeleton
final class ItemLoadingEntity: MainItemEntity { }
