//
//  FontPersistentStoreStrategy.swift
//  GoogleFontPicker
//
//  Created by Greener Chen on 2021/4/17.
//

import Combine
import UIKit

protocol FontPersistentStoreStrategy {
    func getFont(_ webFont: WebFont) -> AnyPublisher<UIFont, Error>
}

enum GoogleFontError: String, Error {
    case fontStyleNotFound
    case fontFileUrlNotFound
    case fontFileCorrupted
    case savefontFileFailed
    case localFontFileNotFound
}
