//
//  ItemInteractor.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 5/03/21.
//

import Foundation
import RxSwift

protocol ItemInteractorProtocol {
    var currentAddress: String { get }
    func queryItem(id: String) -> Single<ItemDetailDTO>
}

final class ItemInteractor: ItemInteractorProtocol {
    // MARK: Attributes
    var currentAddress: String
    private let dataManager: ItemDataManagerProtocol
    
    init(address: String, dataManager: ItemDataManagerProtocol = ItemDataManager()) {
        currentAddress = address
        self.dataManager = dataManager
    }
    
    func queryItem(id: String) -> Single<ItemDetailDTO> {
        return dataManager.queryItem(id: id)
    }
}
