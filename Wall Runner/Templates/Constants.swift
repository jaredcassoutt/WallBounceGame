//
//  Constants.swift
//  Wall Runner
//
//  Created by Jared Cassoutt on 12/8/20.
//

import Foundation
import UIKit

struct ScoreData {
    static let averageScore = "averageScore"
    static let highScore = "highScore"
    static let recentScore = "recentScore"
    static let totalPoints = "totalPoints"
    static let gamesPlayed = "gamesPlayed"
    static let coins = "coins"
}

struct Customizations {
    static let texture = "texture"
    static let bought = "bought"
    static let price = 40
}

struct Images {
    static let store = "store"
    static let logo = "Logo"
    static let background = "background"
    static let click = "click"
    static let coin = "coin"
    static let rightArrow = "right arrow"
    static let leftArrow = "left arrow"
    static let pause = "pause"
}

struct Fonts {
    static let main = "AvenirNext-Bold"
}

struct Runners {
    static let runnerStyle: [String] = ["texture0","texture1","texture2","texture3","texture4","texture5","texture6","texture7","texture8","texture9","texture10","texture11","texture12","texture13","texture14",]
}

struct ObjectNames {
    static let obstacle = "obstacle"
    static let runner = "runner"
    static let coin = "coin"
}

struct Screen {
    static var hasNotch = false
}
