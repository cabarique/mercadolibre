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
    var pictures: [URL] = []
    let originalPrice: Float?
    
    enum CodingKeys: String, CodingKey {
        case id, price, condition, pictures
        case name = "title"
        case soldQuantity = "sold_quantity"
        case originalPrice = "original_price"
    }
    
    enum ContainerCodingKeys: String, CodingKey {
        case body
    }
    
    enum PictureCodingKeys: String, CodingKey {
        case url
    }
    
    struct Pictures: Decodable {
        let id: String
        let url: String?
    }
    
    init(from decoder: Decoder) throws {
        let parentContainer = try decoder.container(keyedBy: ContainerCodingKeys.self)
        let container = try parentContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .body)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Float.self, forKey: .price)
        originalPrice = try? container.decode(Float.self, forKey: .originalPrice)
        soldQuantity = try? container.decode(Int.self, forKey: .soldQuantity)
        condition = try? container.decode(ConditionType.self, forKey: .condition)
        
        // Pictures
        if let picturesContainer = try? container.decode([Pictures].self, forKey: .pictures) {
            pictures = picturesContainer.compactMap { value -> URL? in
                guard let url = value.url else { return nil }
                return URL(string: url)}
        }
    }
}
