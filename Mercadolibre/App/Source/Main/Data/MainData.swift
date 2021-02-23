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
