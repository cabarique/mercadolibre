//
//  ItemPresenter.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 5/03/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol ItemPresenterProtocol {
    func show(_ item: ItemEntity)
}

protocol ItemViewInput {
    var currentAddress: String { get }
    var itemsObservable: Driver<[ItemDetailSection]> { get }
}

final class ItemPresenter: ItemPresenterProtocol {
    // MARK: Attributes
    private let router: ItemRouterProtocol
    private let interactor: ItemInteractorProtocol
    private var item: ItemEntity?
    
    // MARK: Subjects
    private let disposeBag = DisposeBag()
    private let sectionsSubject = ReplaySubject<[ItemDetailSection]>.create(bufferSize: 1)
    
    // MARK: Init
    init(router: ItemRouterProtocol, interactor: ItemInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    func show(_ item: ItemEntity) {
        self.item = item
        router.show(presenter: self)
    }
}

// MARK: ItemViewInput
extension ItemPresenter: ItemViewInput {
    var itemsObservable: Driver<[ItemDetailSection]> {
        return sectionsSubject.asDriver(onErrorDriveWith: .never())
    }
    
    var currentAddress: String {
        interactor.currentAddress
    }
}

// MARK: ItemViewOutput
extension ItemPresenter: ItemViewOutput {
    func viewDidLoad() {
        guard let id = item?.id else { return }
        interactor.queryItem(id: id)
            .asObservable()
            .map { value in
                let header = ItemDetailHeader(name: value.name,
                                              condition: value.condition?.localized,
                                              soldQuantity: value.soldQuantity,
                                              soldBy: nil)
            let headerSection = ItemDetailSection(title: "HEADER", items: [header])
            return [headerSection]
        }.bind(to: sectionsSubject)
        .disposed(by: disposeBag)
        
    }
    
    func back() {
        router.back()
    }
}

private extension ItemDetailDTO.ConditionType {
    var localized: String {
        switch self {
        case .new: return "Nuevo"
        case .used: return "Usado"
        }
    }
}
