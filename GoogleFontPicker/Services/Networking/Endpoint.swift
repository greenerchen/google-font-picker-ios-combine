//
//  Endpoint.swift
//  GoogleFontPicker
//
//  Created by Greener Chen on 2021/4/14.
//

import Foundation

protocol Endpoint {
    var apiKey: String { get }
    var sortCategory: FontSortCategory { get }
    var url: URL? { get }
}

enum FontSortCategory: String {
    case trending
    case popular = "popularity"
    case newest = "date"
    case alphabetical = "alpha"
}

struct FontsEndpoint: Endpoint {
    
    // MARK: - Properties
    let apiKey: String
    let sortCategory: FontSortCategory

    var url: URL? {
        urlOfFontsSorted(by: sortCategory)
    }
    
    // MARK: - Initializer
    init(apiKey: String, sortCategory: FontSortCategory = .trending) {
        self.apiKey = apiKey
        self.sortCategory = sortCategory
    }
}

// MARK: - Helpers
extension FontsEndpoint {
    func urlOfFontsSorted(by category: FontSortCategory) -> URL? {
        return URL(string: "https://www.googleapis.com/webfonts/v1/webfonts?sort=\(category.rawValue)&key=\(apiKey)")
    }
}
