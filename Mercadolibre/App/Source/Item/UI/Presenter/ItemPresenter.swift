//
//  ItemPresenter.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 5/03/21.
//

import Foundation

protocol ItemPresenterProtocol {
    func show(_ item: ItemEntity)
}

protocol ItemViewInput {
    var currentAddress: String { get }
}

final class ItemPresenter: ItemPresenterProtocol {
    // MARK: Attributes
    private let router: ItemRouterProtocol
    private let interactor: ItemInteractorProtocol
    
    // MARK: Init
    init(router: ItemRouterProtocol, interactor: ItemInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    func show(_ item: ItemEntity) {
        router.show(presenter: self)
    }
}

extension ItemPresenter: ItemViewInput {
    var currentAddress: String {
        interactor.currentAddress
    }
}

extension ItemPresenter: ItemViewOutput {
    func back() {
        router.back()
    }
}
