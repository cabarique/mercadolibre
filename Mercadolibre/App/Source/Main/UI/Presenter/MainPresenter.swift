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
    var itemsObservable: Driver<[SectionEntity]> { get }
}

final class MainPresenter: MainPresenterProtocol {
    // MARK: Attributes
    private let router: MainRouterProtocol
    private let interactor: MainInteractorProtocol
    
    // MARK: Subjects
    private let itemsSubject = ReplaySubject<[SectionEntity]>.create(bufferSize: 1)
    private let querySubject = PublishSubject<String>()
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
                    return ItemEntity(id: item.id, name: item.title, imageUrl: url, value: item.price)
                }
            }
            .subscribe { [weak self] items in
                guard let self = self else { return }
                guard items.count > 0 else {
                    let item = ItemErrorEntity(errorMsg: APIError.emptyResults.localizedDescription)
                    let section = SectionEntity(title: "error", items: [item])
                    self.itemsSubject.onNext([section])
                    return
                }
                let section = SectionEntity(title: "bicicleta", items: items)
                self.itemsSubject.onNext([section])
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                let item = ItemErrorEntity(errorMsg: error.localizedDescription)
                let section = SectionEntity(title: "error", items: [item])
                self.itemsSubject.onNext([section])
            }
            .disposed(by: disposeBag)
    }
}

extension MainPresenter: MainViewInput {
    var itemsObservable: Driver<[SectionEntity]> {
        return itemsSubject.asDriver(onErrorDriveWith: .never())
    }
}

extension MainPresenter: MainViewOutput {
    func viewDidLoad() {
        querySubject
            .distinctUntilChanged()
            .throttle(.milliseconds(500), scheduler: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .subscribe(onNext: { [weak self] query in
                guard let self = self else { return }
                self.query(query)
            }).disposed(by: disposeBag)

        query("bicicleta")
    }
    
    private func emitGenericLoading() {
        
        let items: [ItemLoadingEntity] = [ItemLoadingEntity(),
                                          ItemLoadingEntity(),
                                          ItemLoadingEntity(),]
        let section = SectionEntity(title: "loading", items: items)
        itemsSubject.onNext([section])
    }
    
}
