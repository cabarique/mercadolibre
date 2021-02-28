//
//  MainDataManager.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 15/02/21.
//

import Foundation
import RxSwift
import RxAlamofire

/// Service errors
enum APIError: Error {
    case urlMalformed
    case statusError
    case emptyResults
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .urlMalformed: return "Oops, we got an error, please try again."
        case .statusError: return "Oops, we got an error, please try again."
        case .emptyResults: return "No results found for your search."
        }
    }
}

protocol MainDataManagerProtocol {
    func queryItems(_ query: String, limit: Int, offset: Int) -> Single<ItemsDTO>
}

final class MainDataManager: MainDataManagerProtocol {
    private let disposeBag = DisposeBag()
    
    func queryItems(_ query: String, limit: Int, offset: Int) -> Single<ItemsDTO> {
        var components = URLComponents(string: ServiceDefinitions.queryItems)
        components?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "zipcode", value: "CO-DC_TUNPQ1RFVTY1OTk1")
        ]
        
        guard let _components = try? components?.asURL()
        else {
            return .error(APIError.urlMalformed)
        }
        let request = URLRequest(url: _components)
        return Single<ItemsDTO>.create { [weak self] single -> Disposable in
            let disposable = Disposables.create()
            guard let self = self else { return disposable }
            
            let observable: Observable<(HTTPURLResponse, ItemsDTO)> = RxAlamofire.requestDecodable(request)
            observable
                .debug()
                .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                .subscribe(onNext: { (status, response) in
                    guard (200..<300) ~= status.statusCode else {
                        single(.failure(APIError.statusError))
                        return
                    }
                    single(.success(response))
                }, onError: { _ in
                    single(.failure(APIError.statusError))
                })
                .disposed(by: self.disposeBag)
            return disposable
        }
    }
}
