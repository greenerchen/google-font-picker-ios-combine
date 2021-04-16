//
//  UIViewController+Container.swift
//  GoogleFontPicker
//
//  Created by Greener Chen on 2021/4/14.
//

import UIKit

extension UIViewController {
    func add(_ viewController: UIViewController) {
        self.view.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.willMove(toParent: self)
    }
    
    func remove() {
        self.willMove(toParent: nil)
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
}
