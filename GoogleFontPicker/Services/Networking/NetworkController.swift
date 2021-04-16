//
//  NetworkController.swift
//  GoogleFontPicker
//
//  Created by Greener Chen on 2021/4/14.
//

import Foundation
import Combine

protocol NetworkControllerProtocol: class {
    func get<T>(type: T.Type, url: URL, retries: Int) -> AnyPublisher<T, Error> where T: Decodable
    func getFile(url: URL, retries: Int) -> AnyPublisher<Data, URLError>
}

final class NetworkController {
    // MARK: - Properties
    private let session: URLSession
    
    // MARK: - Initializer
    init(session: URLSession = URLSession.shared) {
        self.session = session
        configureSessionCache()
    }
}

// MARK: - Session configurations
extension NetworkController {
    private func configureSessionCache() {
        session.configuration.requestCachePolicy = .returnCacheDataElseLoad
    }
}
 
// MARK: - NetworkControllerProtocol
extension NetworkController: NetworkControllerProtocol {
    func get<T>(type: T.Type, url: URL, retries: Int = 0) -> AnyPublisher<T, Error> where T: Decodable {
        return session.dataTaskPublisher(for: url)
            .retry(retries)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getFile(url: URL, retries: Int = 3) -> AnyPublisher<Data, URLError> {
        return session.dataTaskPublisher(for: url)
            .retry(retries)
            .map(\.data)
            .eraseToAnyPublisher()
    }
}
