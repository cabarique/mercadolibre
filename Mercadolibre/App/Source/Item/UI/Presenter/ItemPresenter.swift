//
//  ItemPresenter.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 5/03/21.
//

import Foundation
import RxSwift
import RxCocoa

enum ItemDetailSectionType: String {
    case header = "HEADER"
    case photos = "PHOTOS"
    case price = "PRICE"
    case buy = "BUY"
    case other
}

protocol ItemPresenterProtocol {
    func show(_ item: ItemEntity)
}

protocol ItemViewInput {
    var currentAddress: String { get }
    var itemsObservable: Driver<[ItemDetailSection]> { get }
    func sectionForIndex(_ index: Int) -> ItemDetailSectionType?
    func sectionItemsForIndex(_ index: Int) -> Int
}

final class ItemPresenter: ItemPresenterProtocol {
    // MARK: Attributes
    private let router: ItemRouterProtocol
    private let interactor: ItemInteractorProtocol
    private var item: ItemEntity?
    
    // MARK: Subjects
    private let disposeBag = DisposeBag()
    private let sectionsSubject = BehaviorRelay<[ItemDetailSection]>(value: [])
    
    // MARK: Init
    init(router: ItemRouterProtocol, interactor: ItemInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    func show(_ item: ItemEntity) {
        self.item = item
        router.show(presenter: self)
    }
    
    private func emitGenericLoading() {
        
        let items: [MainItemDetailLoadingSection] = [MainItemDetailLoadingSection(),
                                                     MainItemDetailLoadingSection(),
                                                     MainItemDetailLoadingSection(),]
        let section = ItemDetailSection(title: "loading", items: items, type: .other)
        sectionsSubject.accept([section])
    }
}

// MARK: ItemViewInput
extension ItemPresenter: ItemViewInput {
    func sectionForIndex(_ index: Int) -> ItemDetailSectionType? {
        guard let value = sectionsSubject.value[safe: index] else { return nil }
        return value.type
    }
    
    func sectionItemsForIndex(_ index: Int) -> Int {
        guard let value = sectionsSubject.value[safe: index] else { return 0 }
        return value.items.count
    }
    
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
        emitGenericLoading()
        guard let id = item?.id else { return }
        interactor.queryItem(id: id)
            .asObservable()
            .map { [weak self] value in
                guard let self = self else { return [] }
                var sections = [ItemDetailSection]()
                let header = ItemDetailHeader(name: value.name,
                                              condition: value.condition?.localized,
                                              soldQuantity: value.soldQuantity,
                                              soldBy: nil)
                let headerSection = ItemDetailSection(title: "HEADER", items: [header], type: .header)
                
                let photos = value.pictures.map { ItemDetailPhoto(url: $0)}
                let photosSection = ItemDetailSection(title: "PHOTOS", items: photos, type: .photos)
                sections = [headerSection, photosSection]
                if let installment = self.item?.installment {
                    var discount: Int? {
                        guard let original = value.originalPrice else { return nil }
                        return Int((1 - (value.price / original)) * 100)
                    }
                    let price = ItemDetailPrice(price: value.price, original: value.originalPrice, discount: discount, installments: installment)
                    let priceSection = ItemDetailSection(title: "PRICE", items: [price], type: .price)
                    sections.append(priceSection)
                }
                
                let buySection = ItemDetailSection(title: "BUY", items: [ItemDetailBuy(link: value.permaLink)], type: .buy)
                sections.append(buySection)
            return sections
        }.bind(to: sectionsSubject)
        .disposed(by: disposeBag)
    }
    
    func back() {
        router.back()
    }
    
    func openLink(url: URL) {
        router.openLink(url: url)
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
