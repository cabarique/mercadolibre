//
//  MainPresenter.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 15/02/21.
//

import Foundation

protocol MainPresenterProtocol {
    func show()
}

final class MainPresenter: MainPresenterProtocol {
    // MARK: Attributes
    private let router: MainRouterProtocol
    private let interactor: MainInteractorProtocol
    
    // MARK: Init
    init(router: MainRouterProtocol, interactor: MainInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    // MARK: MainPresenterProtocol
    func show() {
        router.show(presenter: self)
    }
}
