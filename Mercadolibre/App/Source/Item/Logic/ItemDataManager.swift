//
//  ItemDataManager.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 5/03/21.
//

import Foundation
import RxSwift
import RxAlamofire

protocol ItemDataManagerProtocol {
    func queryItem(id: String) -> Single<ItemDetailDTO>
}

final class ItemDataManager: ItemDataManagerProtocol {
    // MARK: Attributes
    private let disposeBag = DisposeBag()
    
    func queryItem(id: String) -> Single<ItemDetailDTO> {
        
        var components = URLComponents(string: ServiceDefinitions.queryItem)
        components?.queryItems = [
            URLQueryItem(name: "ids", value: id),
            URLQueryItem(name: "attributes", value: "id,price,condition,pictures,title,sold_quantity,original_price,permalink")
        ]
        
        guard let _components = try? components?.asURL()
        else {
            return .error(APIError.urlMalformed)
        }
        let request = URLRequest(url: _components)
        return Single<ItemDetailDTO>.create { [weak self] single -> Disposable in
            let disposable = Disposables.create()
            guard let self = self else { return disposable }
            
            let observable: Observable<(HTTPURLResponse, [ItemDetailDTO])> = RxAlamofire.requestDecodable(request)
            observable
                .debug()
                .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                .subscribe(onNext: { (status, response) in
                    guard (200..<300) ~= status.statusCode else {
                        single(.failure(APIError.statusError))
                        return
                    }
                    if let item = response.first {
                        single(.success(item))
                    } else {
                        single(.failure(APIError.emptyResults))
                    }
                }, onError: { _ in
                    single(.failure(APIError.statusError))
                })
                .disposed(by: self.disposeBag)
            return disposable
        }
    }
}
