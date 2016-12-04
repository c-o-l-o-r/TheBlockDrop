//
//  MGConstants.swift
//  BlockDrop
//
//  Created by Matt Garnett on 8/3/16.
//  Copyright © 2016 Matt Garnett. All rights reserved.
//

import Foundation
import SpriteKit

struct CollisionMask {
    static let Player:UInt32 = 0x00
    static let  Obstacle:UInt32 = 0x01
}

struct LevelColors {
    static let Green = UIColor(red:0.38, green:0.98, blue:0.69, alpha:1.0)
    static let Blue = UIColor(red:0.33, green:0.64, blue:1.00, alpha:1.0)
    static let Yellow = UIColor(red:1.00, green:0.96, blue:0.00, alpha:1.0)
    static let Red = UIColor(red:1.00, green:0.46, blue:0.53, alpha:1.0)
}

let kPLAYER_SIZE = CGSize(width: 25, height: 25)
let kEDGE_EXTENSION_LENGTH = CGFloat(300)
let kGRAVITY = CGVector(dx: 0, dy: -4)
let kLEFT_IMPULSE = CGVector(dx: -3, dy: 14)
let kRIGHT_IMPULSE = CGVector(dx: 3, dy: 14)
let kGAME_SPEED = CGFloat(4)
let kHOLE_SIZE = 110

var playCount = 0
var canShowAds = false
