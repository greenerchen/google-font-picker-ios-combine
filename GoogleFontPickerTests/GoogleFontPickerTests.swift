//
//  GoogleFontPickerTests.swift
//  GoogleFontPickerTests
//
//  Created by Greener Chen on 2021/4/16.
//

import XCTest
import Combine
@testable import GoogleFontPicker

class GoogleFontPickerTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        cancellables = []
        
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testRenderGoogleFontPicker_expectRenderingSucceeds() throws {
        let picker = GoogleFontPicker()
        picker.previewText = "Friday"
        
        
    }
}
