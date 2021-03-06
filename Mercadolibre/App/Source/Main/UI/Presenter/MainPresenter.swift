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

protocol MainViewInput {
    var hasNextPage: Bool { get }
    var currentAddress: String { get }
    var itemsObservable: Driver<[SectionEntity]> { get }
}

final class MainPresenter: MainPresenterProtocol {
    // MARK: Attributes
    private let router: MainRouterProtocol
    private let interactor: MainInteractorProtocol
    private var query: String = "Bicicleta"
    var hasNextPage: Bool {
        interactor.hasNextPage
    }
    private var loadingNext: Bool = false
    
    // MARK: Subjects
    private let itemsSubject = BehaviorRelay<[SectionEntity]>(value: [])
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    init(router: MainRouterProtocol, interactor: MainInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    // MARK: MainPresenterProtocol
    func show() {
        router.show(presenter: self)
    }
    
    private func query(_ query: String) {
        emitGenericLoading()
        interactor.queryItems(query)
            .map { items -> [ItemEntity] in
                return items.map { item -> ItemEntity in
                    let url = URL(string: item.thumbnail)
                    return ItemEntity(id: item.id,
                                      name: item.title,
                                      imageUrl: url,
                                      value: item.price,
                                      installment: item.installments,
                                      attributes: item.attributes)
                }
            }
            .subscribe { [weak self] items in
                guard let self = self else { return }
                guard items.count > 0 else {
                    let item = ItemErrorEntity(errorMsg: APIError.emptyResults.localizedDescription)
                    let section = SectionEntity(title: "error", items: [item])
                    self.itemsSubject.accept([section])
                    return
                }
                let section = SectionEntity(title: "ITEM", items: items)
                if self.interactor.hasNextPage {
                    let loadingItems: [ItemLoadingEntity] = [ItemLoadingEntity()]
                    let loadingSection = SectionEntity(title: "loading", items: loadingItems)
                    self.itemsSubject.accept([section, loadingSection])
                } else {
                    self.itemsSubject.accept([section])
                }
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                let item = ItemErrorEntity(errorMsg: error.localizedDescription)
                let section = SectionEntity(title: "error", items: [item])
                self.itemsSubject.accept([section])
            }
            .disposed(by: disposeBag)
    }
}

extension MainPresenter: MainViewInput {
    var currentAddress: String {
        interactor.currentAddress
    }
    
    var itemsObservable: Driver<[SectionEntity]> {
        return itemsSubject.asDriver(onErrorDriveWith: .never())
    }
}

extension MainPresenter: MainViewOutput {
    func viewDidLoad() {
        query("bicicleta")
    }
    
    private func emitGenericLoading() {
        let items: [ItemLoadingEntity] = [ItemLoadingEntity(),
                                          ItemLoadingEntity(),
                                          ItemLoadingEntity()]
        let section = SectionEntity(title: "loading", items: items)
        itemsSubject.accept([section])
    }
    
    func search(_ query: String) {
        self.query = query
        self.query(query)
    }
    
    func showItem(_ item: ItemEntity) {
        router.showItem(item, address: currentAddress)
    }
    
    func getNextPage() {
        guard interactor.hasNextPage && !loadingNext else { return }
        loadingNext = true
        interactor.nextPage(query)
            .retry(3)
            .map { items -> [ItemEntity] in
                return items.map { item -> ItemEntity in
                    let url = URL(string: item.thumbnail)
                    return ItemEntity(id: item.id,
                                      name: item.title,
                                      imageUrl: url,
                                      value: item.price,
                                      installment: item.installments,
                                      attributes: item.attributes)
                }
            }
            .subscribe(onSuccess: { [weak self] items in
                guard let self = self else { return }
                self.loadingNext = false
                if self.interactor.hasNextPage {
                    let sections = self.itemsSubject.value
                    sections.first?.items.append(contentsOf: items)
                    self.itemsSubject.accept(sections)
                } else {
                    var sections = self.itemsSubject.value
                    sections.first?.items.append(contentsOf: items)
                    sections.removeLast()
                    self.itemsSubject.accept(sections)
                }
            }, onFailure: { [weak self] _ in
                self?.loadingNext = false
            }).disposed(by: disposeBag)
    }
    
}
