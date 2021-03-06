//
//  ItemInteractor.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 5/03/21.
//

import Foundation

protocol ItemInteractorProtocol {
    var currentAddress: String { get }
}

final class ItemInteractor: ItemInteractorProtocol {
    // MARK: Attributes
    var currentAddress: String
    
    init(address: String) {
        currentAddress = address
    }
}
