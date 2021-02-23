//
//  MainDataManager.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 15/02/21.
//

import Foundation
import RxSwift

protocol MainDataManagerProtocol {
    func queryItems(_ query: String, limit: Int, offset: Int) -> Single<ItemsDTO>
}

final class MainDataManager: MainDataManagerProtocol {
    
    func queryItems(_ query: String, limit: Int, offset: Int) -> Single<ItemsDTO> {
        let sections: [ItemDTO] = {
            var items: [ItemDTO] = []
            for i in 0...5 {
                let item = ItemDTO(id: String(i), title: "Item #\(i)", price: Float.random(in: (99999 ..< 1000000)), thumbnail: "")
                items.append(item)
            }
            return items
        }()
        let paging = Paging(total: 232323, results: 1000, offset: 0, limit: 20)
        let items = ItemsDTO(paging: paging, items: sections)
        
        return .just(items)
    }
}
