//
//  ItemDetailData.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 5/03/21.
//

import Foundation

struct ItemDetailDTO: Decodable {
    enum ConditionType: String, Decodable {
        case new, used
    }
    let id: String
    let name: String
    let price: Float
    let soldQuantity: Int?
    let condition: ConditionType?
    
    enum CodingKeys: String, CodingKey {
        case id, price, condition
        case name = "title"
        case soldQuantity = "sold_quantity"
    }
    
    enum ContainerCodingKeys: String, CodingKey {
        case body
    }
    
    init(from decoder: Decoder) throws {
        let parentContainer = try decoder.container(keyedBy: ContainerCodingKeys.self)
        let container = try parentContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .body)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Float.self, forKey: .price)
        soldQuantity = try? container.decode(Int.self, forKey: .soldQuantity)
        condition = try? container.decode(ConditionType.self, forKey: .condition)
    }
}
