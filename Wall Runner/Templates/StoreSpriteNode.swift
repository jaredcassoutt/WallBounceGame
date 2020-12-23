//
//  StoreSpriteNode.swift
//  Wall Runner
//
//  Created by Jared Cassoutt on 12/12/20.
//

import Foundation
import SpriteKit

class TouchableSpriteNode : SKSpriteNode {
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        print("touched")
    }
}
