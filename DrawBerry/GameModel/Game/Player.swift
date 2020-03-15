//
//  Player.swift
//  DrawBerry
//
//  Created by Jon Chua on 14/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

class Player: CustomStringConvertible, Equatable {
    init(name: String, canvasDrawing: Canvas) {
        self.name = name
        self.canvasDrawing = canvasDrawing
    }

    var name: String
    var canvasDrawing: Canvas

    var extraStrokes = 0

    var description: String {
        return "(\(name))"
    }

    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.name == rhs.name
    }
}
