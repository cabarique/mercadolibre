//
//  MainItemEntity.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 23/02/21.
//

import Foundation

/// Defines shared protocol for Entities displayed on Main View
class MainItemEntity: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: MainItemEntity.self))
    }
    
    static func == (lhs: MainItemEntity, rhs: MainItemEntity) -> Bool {
        return false
    }
}

/// Entity defines an error occured during execution
final class ItemErrorEntity: MainItemEntity {
    let errorMsg: String
    
    init(errorMsg: String) {
        self.errorMsg = errorMsg
    }
    
    override func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: ItemErrorEntity.self))
    }
    
    static func == (lhs: ItemErrorEntity, rhs: ItemErrorEntity) -> Bool {
        lhs.errorMsg == rhs.errorMsg
    }
}

/// Loading item skeleton
final class ItemLoadingEntity: MainItemEntity {
    override func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: ItemLoadingEntity.self))
    }
    
    static func == (lhs: ItemLoadingEntity, rhs: ItemLoadingEntity) -> Bool {
        return true
    }
}
