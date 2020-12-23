//
//  GameViewController.swift
//  Wall Runner
//
//  Created by Jared Cassoutt on 12/8/20.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        if view.frame.height > 736 {
            Screen.hasNotch = true
        }
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = MenuScene(size: UIScreen.main.bounds.size)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .fill
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
}
