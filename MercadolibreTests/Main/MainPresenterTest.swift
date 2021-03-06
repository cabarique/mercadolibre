//
//  MainPresenterTest.swift
//  MercadolibreTests
//
//  Created by Luis Cabarique on 6/03/21.
//

import XCTest
import RxSwift
import RxBlocking
@testable import Mercadolibre

final class MainPresenterTest: XCTestCase {
    // MARK: Attributes
    var sot: (MainPresenterProtocol & MainViewOutput & MainViewInput)?
    var interactor: MockMainInteractor?
    var router: MockMainRouter?
    
    override func setUpWithError() throws {
        interactor = MockMainInteractor()
        router = MockMainRouter()
        sot = MainPresenter(router: router!, interactor: interactor!)
    }

    func testShowView() {
        router?.mockShow = {
            XCTAssertTrue(true, "request view controller")
        }
        sot?.show()
    }
    
    func testShowItem() {
        let itemEntity = ItemEntity(name: "name", imageUrl: nil, value: 10, installment: nil)
        router?.mockShowItem = { (item, address) in
            XCTAssertTrue(true, "request item view controller")
            XCTAssertEqual(itemEntity, item)
            XCTAssertEqual(address, self.interactor!.currentAddress)
        }
        sot?.showItem(itemEntity)
    }
    
    func testViewDidLoad_RequestItems_loading() {
        
        do {
            let result = try sot?.itemsObservable.skip(1).do(onSubscribed: {
                self.sot?.viewDidLoad()
            }).toBlocking(timeout: 1).first()
            guard let items = result, let first = items.first else {
                XCTFail("nil results")
                return
            }
            XCTAssertEqual(items.count, 1, "Request items on view did load")
            let loadingItems = first.items as? [ItemLoadingEntity]
            XCTAssertNotNil(loadingItems, "section is loading")
            XCTAssertEqual(loadingItems?.count, 3)
        } catch let error {
            XCTFail("can't get items info data \(error.localizedDescription)")
        }
    }
    
    func testViewDidLoad_RequestItems_isError() {
        
        do {
            let result = try sot?.itemsObservable.asObservable().skip(1).take(2).do(onSubscribed: {
                self.sot?.viewDidLoad()
            }).toBlocking(timeout: 1).toArray()
            guard let items = result, let second = items[safe: 1] else {
                XCTFail("nil results")
                return
            }
            XCTAssertEqual(items.count, 2, "Request items on view did load")
            let itemList = second.first?.items as? [ItemErrorEntity]
            XCTAssertNotNil(itemList, "section is Error")
            XCTAssertEqual(itemList?.first?.errorMsg, APIError.emptyResults.localizedDescription)
        } catch let error {
            XCTFail("can't get items info data \(error.localizedDescription)")
        }
    }

}

final class MockMainInteractor: MainInteractorProtocol {
    var hasNextPage: Bool = false
    
    var currentAddress: String = "current address"
    
    func queryItems(_ query: String) -> Single<[ItemDTO]> {
        .just([])
    }
    
    func nextPage(_ query: String) -> Single<[ItemDTO]> {
        .just([])
    }
}

final class MockMainRouter: MainRouterProtocol {
    var mockShow: (()->())?
    var mockShowItem: ((ItemEntity, String)->())?
    
    func show(presenter: MainViewInput & MainViewOutput) {
        mockShow?()
    }
    
    func showItem(_ item: ItemEntity, address: String) {
        mockShowItem?(item, address)
    }
}
