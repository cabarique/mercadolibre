//
//  ServiceDefinitions.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 28/02/21.
//

import Foundation

struct ServiceDefinitions {
    static let baseUrl = "https://api.mercadolibre.com"
    /// Query list of items
    static let queryItems: String = {
        return baseUrl + "/sites/MCO/search"
    }()
    /// Query single item
    static let queryItem: String = {
        return baseUrl + "/items"
    }()
}
