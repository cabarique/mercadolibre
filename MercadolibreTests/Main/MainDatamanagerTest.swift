//
//  MainDatamanagerTest.swift
//  MercadolibreTests
//
//  Created by Luis Cabarique on 6/03/21.
//

import XCTest
import RxSwift
import RxBlocking
import OHHTTPStubs
@testable import Mercadolibre

class MainDatamanagerTest: XCTestCase {
    var sot: MainDataManagerProtocol?
    override func setUpWithError() throws {
        sot = MainDataManager()
    }
    
    override func tearDownWithError() throws {
        HTTPStubs.removeAllStubs()
    }

    func testQueryItemsDataIntegrity() {
        do {
            let pattern: String = ".*sites/MCO/search"
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            
            defaultStub(regex: regex, jsonMock: "ItemsMock")
            let results = try sot!.queryItems("bicicleta", limit: 20, offset: 0).toBlocking(timeout: 1).first()
            guard let item = results, let first = item.items.first else {
                XCTFail("empty results")
                return
            }
            XCTAssertEqual(item.items.count, 20, "20 results found")
            /// Paging tests
            XCTAssertEqual(item.paging.total, 20935, "20 total results found")
            XCTAssertEqual(item.paging.offset, 0, "pagin offset 0")
            XCTAssertEqual(item.paging.limit, 20, "20 results per page")
            
            ///first result tests
            XCTAssertEqual(first.id, "MCO532672853")
            XCTAssertEqual(first.thumbnail, "http://http2.mlstatic.com/D_762159-MCO32985840437_112019-O.jpg")
            XCTAssertEqual(first.title, "Bicicicleta Roadmaster Hurricane 29  Shimano Revoshift 21vel")
            
            ///installment tests
            XCTAssertEqual(first.installments.amount, 16663.89)
            XCTAssertEqual(first.installments.quantity, 36)
            
            ///attribute tests
            XCTAssertEqual(first.attributes.count, 4)
            
        } catch let error {
            XCTFail("can't get items info data \(error.localizedDescription)")
        }
        
    }
    
    private func defaultStub(regex: NSRegularExpression, jsonMock: String) {
        stub(condition: pathMatches(regex)) { _ in
            guard let stubPath = Bundle(for: MainDatamanagerTest.self)
                .path(forResource: jsonMock, ofType: "json") else {
                    return HTTPStubsResponse()
            }
            let response = fixture(filePath: stubPath, headers: ["Content-Type": "application/json"])
            return response
        }
    }
}
