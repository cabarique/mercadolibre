//
//  MainInteractor.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 15/02/21.
//

import Foundation

protocol MainInteractorProtocol {
    
}

final class MainInteractor: MainInteractorProtocol {
    
    // MARK: Attributes
    let dataManager: MainDataManagerProtocol
    
    init(dataManager: MainDataManagerProtocol = MainDataManager()) {
        self.dataManager = dataManager
    }
}
