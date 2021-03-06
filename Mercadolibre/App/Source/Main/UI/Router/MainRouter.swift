//
//  MainRouter.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 15/02/21.
//

import Foundation
import UIKit

protocol MainRouterProtocol {
    func show(presenter: MainViewInput & MainViewOutput)
    func showItem(_ item: ItemEntity, address: String)
}

final class MainRouter: MainRouterProtocol {
    
    // MARK: Attributes
    private weak var baseController: UIViewController?
    private var navigation: UINavigationController? {
        baseController as? UINavigationController
    }
    
    init(baseController: UIViewController?) {
        self.baseController = baseController
    }
    
    func show(presenter: MainViewInput & MainViewOutput) {
        let vc = MainViewController(presenter: presenter)
        navigation?.pushViewController(vc, animated: true)
    }
    
    func showItem(_ item: ItemEntity, address: String) {
        ItemModule(baseController: navigation, address: address).show(item)
    }
}
