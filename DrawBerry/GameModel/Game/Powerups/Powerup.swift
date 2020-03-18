//
//  Powerup.swift
//  DrawBerry
//
//  Created by Jon Chua on 15/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

protocol Powerup {
    var image: UIImage? { get }
    var targets: [Player] { get set }
    var location: CGPoint { get set }
}

protocol TogglePowerup: Powerup {
    var duration: Double { get set }

    mutating func activate()
    mutating func deactivate()
}

protocol LastingPowerup: Powerup {
    mutating func activate()
}
