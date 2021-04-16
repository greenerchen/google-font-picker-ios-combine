//
//  GoogleFontPickerTests.swift
//  GoogleFontPickerTests
//
//  Created by Greener Chen on 2021/4/14.
//

import XCTest
import Combine
@testable import GoogleFontPicker

class GoogleFontAPITests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        cancellables = []
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testTrendingFontsEndpoint_expectUrlOfTrendingFonts() throws {
        let endpoint = FontsEndpoint(apiKey: "12345678", sortCategory: .trending)
        
        XCTAssertEqual(endpoint.url!.absoluteString, "https://www.googleapis.com/webfonts/v1/webfonts?sort=trending&key=12345678")
    }

    func testWebFontDecoding_expectDecodingSucceeds() throws {
        let jsonString = """
        {
              "family": "Poppins",
              "variants": [
                "100",
                "100italic",
                "200",
                "200italic",
                "300",
                "300italic",
                "regular",
                "italic",
                "500",
                "500italic",
                "600",
                "600italic",
                "700",
                "700italic",
                "800",
                "800italic",
                "900",
                "900italic"
              ],
              "subsets": [
                "devanagari",
                "latin",
                "latin-ext"
              ],
              "version": "v15",
              "lastModified": "2020-11-06",
              "files": {
                "100": "http://fonts.gstatic.com/s/poppins/v15/pxiGyp8kv8JHgFVrLPTed3FBGPaTSQ.ttf",
                "100italic": "http://fonts.gstatic.com/s/poppins/v15/pxiAyp8kv8JHgFVrJJLmE3tFOvODSVFF.ttf",
                "200": "http://fonts.gstatic.com/s/poppins/v15/pxiByp8kv8JHgFVrLFj_V1tvFP-KUEg.ttf",
                "200italic": "http://fonts.gstatic.com/s/poppins/v15/pxiDyp8kv8JHgFVrJJLmv1plEN2PQEhcqw.ttf",
                "300": "http://fonts.gstatic.com/s/poppins/v15/pxiByp8kv8JHgFVrLDz8V1tvFP-KUEg.ttf",
                "300italic": "http://fonts.gstatic.com/s/poppins/v15/pxiDyp8kv8JHgFVrJJLm21llEN2PQEhcqw.ttf",
                "regular": "http://fonts.gstatic.com/s/poppins/v15/pxiEyp8kv8JHgFVrFJDUc1NECPY.ttf",
                "italic": "http://fonts.gstatic.com/s/poppins/v15/pxiGyp8kv8JHgFVrJJLed3FBGPaTSQ.ttf",
                "500": "http://fonts.gstatic.com/s/poppins/v15/pxiByp8kv8JHgFVrLGT9V1tvFP-KUEg.ttf",
                "500italic": "http://fonts.gstatic.com/s/poppins/v15/pxiDyp8kv8JHgFVrJJLmg1hlEN2PQEhcqw.ttf",
                "600": "http://fonts.gstatic.com/s/poppins/v15/pxiByp8kv8JHgFVrLEj6V1tvFP-KUEg.ttf",
                "600italic": "http://fonts.gstatic.com/s/poppins/v15/pxiDyp8kv8JHgFVrJJLmr19lEN2PQEhcqw.ttf",
                "700": "http://fonts.gstatic.com/s/poppins/v15/pxiByp8kv8JHgFVrLCz7V1tvFP-KUEg.ttf",
                "700italic": "http://fonts.gstatic.com/s/poppins/v15/pxiDyp8kv8JHgFVrJJLmy15lEN2PQEhcqw.ttf",
                "800": "http://fonts.gstatic.com/s/poppins/v15/pxiByp8kv8JHgFVrLDD4V1tvFP-KUEg.ttf",
                "800italic": "http://fonts.gstatic.com/s/poppins/v15/pxiDyp8kv8JHgFVrJJLm111lEN2PQEhcqw.ttf",
                "900": "http://fonts.gstatic.com/s/poppins/v15/pxiByp8kv8JHgFVrLBT5V1tvFP-KUEg.ttf",
                "900italic": "http://fonts.gstatic.com/s/poppins/v15/pxiDyp8kv8JHgFVrJJLm81xlEN2PQEhcqw.ttf"
              },
              "category": "sans-serif",
              "kind": "webfonts#webfont"
            }
        """
        let data = jsonString.data(using: .utf8)!
        let webFont = try JSONDecoder().decode(WebFont.self, from: data)
        
        XCTAssertEqual(webFont.kind, "webfonts#webfont")
        XCTAssertEqual(webFont.family, "Poppins")
    }
    
    func testTrendingFontsEndpointRequest_expectWebFontListOfTrendingFonts() throws {
        let endpoint = FontsEndpoint(apiKey: "PUT YOUR API KEY HERE", sortCategory: .trending)
        let networkController = NetworkController()
        let apiCallExpectation: XCTestExpectation = expectation(description: "Api call")
        var fonts = [WebFont]()
        var error: Error?
        
        networkController
            .get(type: WebFontList.self, url: endpoint.url!)
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let requestError):
                    error = requestError
                }
                apiCallExpectation.fulfill()
            } receiveValue: { (fontList) in
                fonts = fontList.items
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(error)
        XCTAssert(fonts.count > 0, "No fonts")
    }
}
