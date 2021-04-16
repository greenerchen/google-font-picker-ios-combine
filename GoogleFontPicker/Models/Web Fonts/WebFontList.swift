//
//  WebFontList.swift
//  GoogleFontPicker
//
//  Created by Greener Chen on 2021/4/14.
//

import Foundation

struct WebFontList: Codable {
    var kind: String    // "webfonts#webfontList"
    var items: [WebFont]
    
    enum CodingKeys: String, CodingKey {
        case kind
        case items
    }
}
