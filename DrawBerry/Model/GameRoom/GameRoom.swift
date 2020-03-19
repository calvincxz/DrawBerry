//
//  GameRoom.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Firebase

class GameRoom {
    static let maxPlayers = 8
    static let minStartablePlayers = 0 // for testing, change to 3 for game

    weak var delegate: GameRoomDelegate?
    let roomNetworkAdapter: RoomNetworkAdapter
    let roomCode: String
    private(set) var players: [RoomPlayer]
    var canStart: Bool {
        players.count >= GameRoom.minStartablePlayers && players.count <= GameRoom.maxPlayers
    }

    init(roomCode: String) {
        self.roomNetworkAdapter = RoomNetworkAdapter()
        self.roomCode = roomCode
        self.players = []

        roomNetworkAdapter.observeRoomPlayers(roomCode: roomCode, listener: { [weak self] players in
            self?.players = players
            self?.delegate?.playersDidUpdate()
        })
    }
}
