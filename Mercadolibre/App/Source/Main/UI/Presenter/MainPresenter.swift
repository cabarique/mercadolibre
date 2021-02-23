//
//  MainPresenter.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 15/02/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol MainPresenterProtocol {
    func show()
}

final class MainPresenter: MainPresenterProtocol {
    // MARK: Attributes
    private let router: MainRouterProtocol
    private let interactor: MainInteractorProtocol
    
    // MARK: Subjects
    private let itemsSubject = PublishSubject<[SectionEntity]>()
    
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

extension MainPresenter: MainViewInput {
    var itemsObservable: Driver<[SectionEntity]> {
        let sections: [SectionEntity] = {
            var items: [ItemEntity] = []
            for i in 0...5 {
                let item = ItemEntity(name: "Item #\(i)", imageUrl: "", value: Float.random(in: (99999 ..< 1000000)))
                items.append(item)
            }
            return [SectionEntity(title: "Items", items: items)]
        }()
        return .just(sections)
//        return itemsSubject.asDriver(onErrorDriveWith: .never())
    }
}
