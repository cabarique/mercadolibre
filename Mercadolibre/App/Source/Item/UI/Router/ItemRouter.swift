//
//  ItemRouter.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 5/03/21.
//

import Foundation
import UIKit

protocol ItemRouterProtocol {
    func show(presenter: ItemViewInput & ItemViewOutput)
    func back()
    func openLink(url: URL)
}

final class ItemRouter: ItemRouterProtocol {
    
    // MARK: Attributes
    private weak var baseController: UIViewController?
    private var navigation: UINavigationController? {
        baseController as? UINavigationController
    }
    
    init(baseController: UIViewController?) {
        self.baseController = baseController
    }
    
    func show(presenter: ItemViewInput & ItemViewOutput) {
        let vc = ItemViewController(presenter: presenter)
        navigation?.pushViewController(vc, animated: false)
    }
    
    func back() {
        navigation?.popViewController(animated: true)
    }
    
    func openLink(url: URL) {
        UIApplication.shared.open(url)
    }
}
