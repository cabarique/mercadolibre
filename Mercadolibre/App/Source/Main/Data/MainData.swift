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
    
    enum CodingKeys: String, CodingKey {
        case total, offset, limit
        case results = "primary_results"
    }
    
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
    
    enum CodingKeys: String, CodingKey {
        case paging
        case items = "results"
    }
}

struct ItemDTO: Decodable {
    let id: String
    let title: String
    let price: Float
    let thumbnail: String
    let installments: Installment
    let attributes: [ItemAttribute]
}

struct Installment: Decodable {
    let quantity: Int
    let amount: Float
}

struct ItemAttribute: Decodable {
    let type: ItemAttributeType
    let name: String?
    let value: String?
    
    enum CodingKeys: String, CodingKey {
        case type = "id"
        case value = "value_name"
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try? container.decode(String.self, forKey: .name)
        value = try? container.decode(String.self, forKey: .value)
        type = (try? container.decode(ItemAttributeType?.self, forKey: .type)) ?? .other
    }
}

enum ItemAttributeType: String, Decodable {
    case brand = "BRAND"
    case condition = "ITEM_CONDITION"
    case model = "MODEL"
    case other
}
