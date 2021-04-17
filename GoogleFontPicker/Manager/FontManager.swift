//
//  FontManager.swift
//  GoogleFontPicker
//
//  Created by Greener Chen on 2021/4/14.
//

import Combine
import UIKit

class FontManager {
    // MARK: - Singleton instance
    static let shared = FontManager()
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var remoteStore = GoogleFontPersistentStore()
    private var localStore = FontPersistentStore()
    var webfonts = [WebFont]()
    
    init() {
        bindWebFonts()
    }
}

// MARK: - Data binding
extension FontManager {
    private func bindWebFonts() {
        remoteStore.getFonts()
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print(" Couldn't get fonts: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [unowned self] (webfonts) in
                self.webfonts = webfonts
            }
            .store(in: &cancellables)
    }
}

extension FontManager {
    func getFont(_ webFont: WebFont) -> AnyPublisher<UIFont, Error> {
        do {
            if let font = try getLocalFont(of: webFont) {
                return Future { promise in
                    promise(.success(font))
                }
                .eraseToAnyPublisher()
            }
        } catch {
            return Fail<UIFont,Error>(error: error)
                .eraseToAnyPublisher()
        }
        return remoteStore.getFont(webFont)
    }
    
    func getLocalFont(of font: WebFont) throws -> UIFont? {
        return try localStore.getFont(of: font)
    }
}
