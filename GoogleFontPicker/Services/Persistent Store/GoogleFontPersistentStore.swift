//
//  GoogleFontPersistentStore.swift
//  GoogleFontPicker
//
//  Created by Greener Chen on 2021/4/14.
//

import Foundation
import UIKit
import Combine

class GoogleFontPersistentStore {
    // MAKR: - Properties
    private var networkController: NetworkController = NetworkController()
    private var googleFontsApiKey = "AIzaSyBvS_AsZDcZjwEDoi_Lvg6YUTkSPx4bE6Y" // PUT YOUR API KEY HERE
    private var cancellables = Set<AnyCancellable>()
    private var localFontStore = FontPersistentStore()
}

// MARK: Get fonts from remote fonts service
extension GoogleFontPersistentStore: FontPersistentStoreStrategy {
    func getFonts() -> AnyPublisher<[WebFont], Error> {
        let endpoint = FontsEndpoint(apiKey: googleFontsApiKey, sortCategory: .trending)
        return networkController.get(type: WebFontList.self, url: endpoint.url!)
            .share()
            .map(\.items)
            .eraseToAnyPublisher()
    }
    
    /// Get the font file (.ttf) from web url
    func getFontData(_ webFont: WebFont) -> AnyPublisher<Data, Error> {
        guard let fontStyle = webFont.variants.first else {
            return Fail<Data, Error>(error: GoogleFontError.fontStyleNotFound)
                .eraseToAnyPublisher()
        }
        guard let url = webFont.files[fontStyle] else {
            return Fail<Data, Error>(error: GoogleFontError.fontFileUrlNotFound)
                .eraseToAnyPublisher()
        }
        return networkController.getFile(url: url)
            .tryMap { [weak self] (data) -> Data in
                try self?.save(data, forWebFont: webFont)
                return data
            }
            .eraseToAnyPublisher()
    }
    
    func getFont(_ webFont: WebFont) -> AnyPublisher<UIFont, Error> {
        return getFontData(webFont)
            .tryMap { (data) -> UIFont in
                guard let ctFontDescriptor = CTFontManagerCreateFontDescriptorFromData(data as CFData) else {
                    throw GoogleFontError.fontFileCorrupted
                }
                let font: UIFont = CTFontCreateWithFontDescriptor(ctFontDescriptor, 0.0, nil) as UIFont
                return font
            }        
            .eraseToAnyPublisher()
    }
}

// MARK: - Save to local files
extension GoogleFontPersistentStore {
    private func save(_ data: Data, forWebFont webFont: WebFont) throws {
        try localFontStore.save(data, forWebFont: webFont)
    }
}
