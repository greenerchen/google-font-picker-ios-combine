//
//  WebFont.swift
//  GoogleFontPicker
//
//  Created by Greener Chen on 2021/4/14.
//

import Foundation

class WebFont: Decodable {
    // MARK: - Properties
    var kind: String    // "webfonts#webfont"
    var family: String
    var variants: [Style]
    var subsets: [String]
    var version: String
    var lastModified: Date
    var files: [Style:URL]
    var localFiles: [Style:URL] = [:]
    
    enum Style: String {
        case thin = "100"
        case thinItalic = "100italic"
        case extraLight = "200"
        case extraLightItalic = "200italic"
        case light = "300"
        case lightItalic = "300italic"
        case regular // 400
        case italic  // 400 italic
        case medium = "500"
        case mediumItalic = "500italic"
        case semiBold = "600"
        case semiBoldItalic = "600italic"
        case bold = "700"
        case boldItalic = "700italic"
        case extraBold = "800"
        case extraBoldItalic = "800italic"
        case black = "900"
        case blackItalic = "900italic"
    }
    
    enum CodingKeys: String, CodingKey {
        case kind
        case family
        case variants
        case subsets
        case version
        case lastModified
        case files
    }

    // MARK: - Initializers
    init(kind: String,    // "webfonts#webfont"
         family: String,
         variants: [Style],
         subsets: [String],
         version: String,
         lastModified: Date,
         files: [Style:URL],
         localFiles: [Style:URL] = [:]) {
        self.kind = kind
        self.family = family
        self.variants = variants
        self.subsets = subsets
        self.version = version
        self.lastModified = lastModified
        self.files = files
        self.localFiles = localFiles
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        kind = try container.decode(String.self, forKey: .kind)
        family = try container.decode(String.self, forKey: .family)
        variants = try container.decode([String].self, forKey: .variants).map { Style(rawValue: $0)! }
        subsets = try container.decode([String].self, forKey: .subsets)
        version = try container.decode(String.self, forKey: .version)
        
        let lastModifiedString = try container.decode(String.self, forKey: .lastModified)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        lastModified = dateFormatter.date(from: lastModifiedString)!
        
        let filesMap = try container.decode([String:String].self, forKey: .files)
        files = [:]
        for (k, v) in filesMap {
            files[Style(rawValue: k)!] = URL(string: v)!
        }
    }
}

extension WebFont: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(kind, forKey: .kind)
        try container.encode(family, forKey: .family)
        try container.encode(variants.map { $0.rawValue }, forKey: .variants)
        try container.encode(subsets, forKey: .subsets)
        try container.encode(version, forKey: .version)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        try container.encode(dateFormatter.string(from: lastModified), forKey: .lastModified)
        
        var fileMap = [String:String]()
        for (k, v) in files {
            fileMap[k.rawValue] = v.absoluteString
        }
        try container.encode(fileMap, forKey: .files)
    }
}

extension WebFont: Equatable {
    static func == (lhs: WebFont, rhs: WebFont) -> Bool {
        return lhs.family == rhs.family &&
            lhs.version == rhs.version &&
            lhs.lastModified == rhs.lastModified
    }
}
