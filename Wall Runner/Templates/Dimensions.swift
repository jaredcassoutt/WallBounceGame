//
//  Dimensions.swift
//  Wall Runner
//
//  Created by Jared Cassoutt on 12/15/20.
//

import Foundation
import SpriteKit

protocol Dimensions { }
extension Dimensions where Self: SKScene {

    
    var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}
