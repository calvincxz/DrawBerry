//
//  TeamBattleGameDelegate.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

protocol TeamBattleGameDelegate: AnyObject {
    func updateDrawing(_ image: UIImage, for round: Int)
}
