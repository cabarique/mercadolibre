//
//  ItemModule.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 5/03/21.
//

import Foundation
import UIKit

final class ItemModule {
    private let presenter: ItemPresenterProtocol
    
    init(baseController: UIViewController?,
         presenter: ItemPresenterProtocol? = nil,
         address: String) {
        if let presenter = presenter {
            self.presenter = presenter
        } else {
            let interactor = ItemInteractor(address: address)
            let router = ItemRouter(baseController: baseController)
            self.presenter = ItemPresenter(router: router, interactor: interactor)
        }
    }
    
    func show(_ item: ItemEntity) {
        presenter.show(item)
    }
}
