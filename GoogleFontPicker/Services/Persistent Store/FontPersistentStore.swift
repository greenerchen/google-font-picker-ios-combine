//
//  FontPersistentStore.swift
//  GoogleFontPicker
//
//  Created by Greener Chen on 2021/4/17.
//

import Combine
import UIKit

class FontPersistentStore {
    // MAKR: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Initializers
    init() {
        makeFontDir()
    }
}

// MARK: - Get fonts from local files
extension FontPersistentStore {
    /// Get the local font file of the first style variant of webfont
    func getFont(of font: WebFont) throws -> UIFont? {
        let data: Data
        guard let style = font.variants.first,
              let localFileUrl = font.localFiles[style] else { return nil }
        do {
            data = try Data(contentsOf: localFileUrl)
        } catch {
            throw GoogleFontError.fontFileCorrupted
        }
        
        guard let ctFontDescriptor = CTFontManagerCreateFontDescriptorFromData(data as CFData) else {
            throw GoogleFontError.fontFileCorrupted
        }
        let font: UIFont = CTFontCreateWithFontDescriptor(ctFontDescriptor, 0.0, nil) as UIFont
        
        return font
    }
    
    private func makeFontDir() {
        if let appDirectoryPath = Bundle.main.resourcePath {
            let webCacheDirectoryPath = appDirectoryPath + "/WebFonts"
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: webCacheDirectoryPath) {
                do {
                    try fileManager.createDirectory(atPath: webCacheDirectoryPath, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error)
                }
            }
        }
    }
}
