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
    private lazy var fontDirectoryURL: URL? = {
        guard let appDirectoryURL = Bundle.main.resourceURL else { return nil }
        let fontDirectoryURL = appDirectoryURL
            .appendingPathComponent("WebFonts", isDirectory: true)
        return fontDirectoryURL
    }()
    
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
        if let fontDirectoryURL = fontDirectoryURL {
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: fontDirectoryURL.absoluteString) {
                do {
                    try fileManager.createDirectory(atPath: fontDirectoryURL.absoluteString, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error)
                }
            }
        }
    }
}

// MARK: - Save to local files
extension FontPersistentStore {
    func save(_ data: Data, forWebFont webFont: WebFont) throws {
        if let fontDirectoryURL = fontDirectoryURL?
            .appendingPathComponent(webFont.family, isDirectory: true) {
            let fontFileURL = fontDirectoryURL.appendingPathComponent(UUID().uuidString)
            
            do {
                let fileManager = FileManager.default
                if !fileManager.fileExists(atPath: fontDirectoryURL.absoluteString) {
                    try fileManager.createDirectory(at: fontDirectoryURL, withIntermediateDirectories: true, attributes: nil)
                }
                try data.write(to: fontFileURL)
                if let style = webFont.variants.first {
                    webFont.localFiles[style] = fontFileURL
                }
            } catch {
                throw GoogleFontError.savefontFileFailed
            }
        }
    }
}
