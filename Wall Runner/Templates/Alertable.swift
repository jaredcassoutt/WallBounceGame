//
//  Alertable.swift
//  Wall Runner
//
//  Created by Jared Cassoutt on 12/15/20.
//

import Foundation
import SpriteKit

protocol Alertable { }
extension Alertable where Self: SKScene {

    func showAlert(withTitle title: String, message: String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alertController.addAction(okAction)

        view?.window?.rootViewController?.present(alertController, animated: true)
    }
    
}
