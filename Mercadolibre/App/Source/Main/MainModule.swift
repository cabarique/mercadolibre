//
//  MainModule.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 15/02/21.
//

import Foundation
import UIKit

final class MainModule {
    private let presenter: MainPresenterProtocol
    
    init(baseController: UIViewController?, presenter: MainPresenterProtocol? = nil) {
        if let presenter = presenter {
            self.presenter = presenter
        } else {
            let interactor = MainInteractor()
            let router = MainRouter(baseController: baseController)
            self.presenter = MainPresenter(router: router, interactor: interactor)
        }
    }
    
    func show() {
        presenter.show()
    }
}
