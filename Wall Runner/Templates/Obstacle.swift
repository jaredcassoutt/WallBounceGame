//
//  Obstacle.swift
//  Wall Runner
//
//  Created by Jared Cassoutt on 12/8/20.
//

import Foundation

class Obstacle {
    var side: String
    var type: String
    var distance: Int
    init(side:String,type:String, distance: Int) {
        self.side = side
        self.type = type
        self.distance = distance
    }
}


