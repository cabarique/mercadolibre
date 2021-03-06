//
//  MainInteractorTest.swift
//  MercadolibreTests
//
//  Created by Luis Cabarique on 6/03/21.
//

import XCTest
import RxSwift
import RxBlocking
@testable import Mercadolibre

class MainInteractorTest: XCTestCase {
    var sot: MainInteractorProtocol?
    var datamanager: MockMainDatamanager?
    override func setUpWithError() throws {
        datamanager = MockMainDatamanager()
        sot = MainInteractor(dataManager: datamanager!)
    }

    func testQueryItemsCallDatamanager() throws {
        let paging = Paging(total: 100, results: 100, offset: 0, limit: 10)
        let installment = Installment(quantity: 1, amount: 100)
        let items = [ItemDTO(id: "id", title: "mock", price: 100, thumbnail: "", installments: installment, attributes: [])]
        datamanager?.queryItemsMock = ItemsDTO(paging: paging, items: items)
        let result = try? sot?.queryItems("query").toBlocking().first()
        XCTAssertNotNil(result, "Datamanager integration")
    }

}

/// Main datamanager mocks
final class MockMainDatamanager: MainDataManagerProtocol {
    var queryItemsMock: ItemsDTO?
    
    func queryItems(_ query: String, limit: Int, offset: Int) -> Single<ItemsDTO> {
        if let mock = queryItemsMock {
            return .just(mock)
        } else {
            return .never()
        }
    }
    
    
}
