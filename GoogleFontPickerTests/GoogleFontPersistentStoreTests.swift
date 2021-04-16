//
//  GoogleFontPersistentStoreTests.swift
//  GoogleFontPickerTests
//
//  Created by Greener Chen on 2021/4/16.
//

import XCTest
import Combine
@testable import GoogleFontPicker

class GoogleFontPersistentStoreTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        cancellables = []
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testGetFonts_expectWebFonts() throws {
        let store = GoogleFontPersistentStore()
        let fontsExpectation: XCTestExpectation = expectation(description: "Get web fonts")
        var fonts = [WebFont]()
        var error: Error?
        
        store.getFonts()
            .sink { (completion) in
                switch completion {
                case .failure(let urlError):
                    error = urlError
                case .finished:
                    break
                }
                fontsExpectation.fulfill()
            } receiveValue: { (webfonts) in
                fonts = webfonts
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 10)
        
        XCTAssertNil(error, "Error happened when getting web fonts")
        XCTAssert(fonts.count > 0, "No web fonts received \(fonts)")
        let webfont = fonts.first!
        XCTAssertEqual(webfont.kind, "webfonts#webfont")
    }
    
    func testStoreGetsFontsDuringInit_expectWebFontsInStore() {
        let store = GoogleFontPersistentStore()
        sleep(1)
        XCTAssert(store.webfonts.count > 0, "The font store has no web fonts received \(store.webfonts)")
    }
    
    func testGetUIFontFromWebUrl_expectUIFont() {
        let store = GoogleFontPersistentStore()
        sleep(1)
        let webfont = store.webfonts.first!
        let fontExpectation: XCTestExpectation = expectation(description: "Convert web font to UIFont")
        var font: UIFont?
        var error: Error?
        
        store.getFont(webfont)
            .sink { (completion) in
                switch completion {
                case .failure(let convertionError):
                    error = convertionError
                case .finished:
                    break
                }
                fontExpectation.fulfill()
            } receiveValue: { (uifont) in
                font = uifont
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 10)
        
        XCTAssertNil(error, "UIFont conversion failed - \(error!)")
        XCTAssertNotNil(font, "UIFont conversion failed")
        XCTAssert(type(of: font!) == UIFont.self, "UIFont conversion failed - \(String(describing: font.self))")
    }
}
