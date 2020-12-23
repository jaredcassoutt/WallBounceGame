//
//  Settings.swift
//  Wall Runner
//
//  Created by Jared Cassoutt on 12/8/20.
//

import Foundation

enum PhysicsCategories {
    static let none: UInt32 = 0
    static let runnerCategory: UInt32 = 0x1 //01
    static let obstacleCategory: UInt32 = 0x1 << 1 //10
    static let coinCategory: UInt32 = 0x1 << 1 //10
}
