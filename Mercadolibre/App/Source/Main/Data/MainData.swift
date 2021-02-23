//
//  MainData.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 23/02/21.
//

import Foundation

struct ItemState<T: MainItemEntity> {
    enum State {
        case loading, success, error
    }
    let item: T? = nil
}

class Paging: Decodable {
    let total: Int
    let results: Int
    let offset: Int
    let limit: Int
    
    init(total: Int, results: Int, offset: Int, limit: Int) {
        self.total = total
        self.results = results
        self.offset = offset
        self.limit = limit
    }
}

struct ItemsDTO: Decodable {
    let paging: Paging
    let items: [ItemDTO]
}

struct ItemDTO: Decodable {
    let id: String
    let title: String
    let price: Float
    let thumbnail: String
}
