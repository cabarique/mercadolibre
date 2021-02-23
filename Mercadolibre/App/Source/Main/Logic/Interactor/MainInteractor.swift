//
//  MainInteractor.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 15/02/21.
//

import Foundation
import RxSwift

protocol MainInteractorProtocol {
    func queryItems(_ query: String) -> Single<[ItemDTO]>
    func nextPage(_ query: String) -> Single<[ItemDTO]>
}

final class MainInteractor: MainInteractorProtocol {
    
    // MARK: Attributes
    private let dataManager: MainDataManagerProtocol
    private var paging: Paging
    private var items = [ItemDTO]()
    
    init(dataManager: MainDataManagerProtocol = MainDataManager()) {
        self.dataManager = dataManager
        paging = Paging(total: 0, results: 0, offset: 0, limit: 20)
    }
    
    func queryItems(_ query: String) -> Single<[ItemDTO]> {
        return dataManager.queryItems(query, limit: paging.limit, offset: 0)
            .do(onSuccess: { [weak self] in
                guard let self = self else { return }
                self.paging = $0.paging
            })
            .map { $0.items }
    }
    
    func nextPage(_ query: String) -> Single<[ItemDTO]> {
        let givenOffset = ((paging.limit * paging.offset) < paging.total) ? (paging.offset + paging.limit) : nil
        guard let offset = givenOffset else { return .just([]) }
        return dataManager.queryItems(query, limit: paging.limit, offset: offset)
            .do(onSuccess: { [weak self] in
                guard let self = self else { return }
                self.paging = $0.paging
            })
            .map { [weak self] in
                guard let self = self else { return [] }
                self.items.append(contentsOf: $0.items)
                return self.items
            }
    }
}
