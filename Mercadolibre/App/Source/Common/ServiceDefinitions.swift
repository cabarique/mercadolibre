//
//  ServiceDefinitions.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 28/02/21.
//

import Foundation

struct ServiceDefinitions {
    static let baseUrl = "https://api.mercadolibre.com/sites/MCO"
    static let queryItems: String = {
        return baseUrl + "/search"
    }()
}
