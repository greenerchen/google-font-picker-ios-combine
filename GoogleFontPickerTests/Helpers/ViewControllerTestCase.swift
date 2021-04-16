//
//  ViewControllerTestCase.swift
//  GoogleFontPickerTests
//
//  Created by Greener Chen on 2021/4/16.
//

import XCTest
import Combine
@testable import GoogleFontPicker

class ViewControllerTestCase: XCTestCase {
    var rootWindow: UIWindow {
        return sceneDelegate.window!
    }
    
    var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
//    var sceneDelegate: SceneDelegate {
//        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            let window = UIWindow(windowScene: scene)
//            
//        }
//    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
}
