//
//  CooperativeGame.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

class CooperativeGame {
    weak var delegate: CooperativeGameDelegate?
    weak var viewingDelegate: CooperativeGameViewingDelegate?
    let networkAdapter: GameNetworkAdapter
    let roomCode: RoomCode
    var allDrawings: [UIImage] = []
    private(set) var players: [CooperativePlayer] {
        didSet {
            players.sort()
        }
    }
    let userIndex: Int // players contains user too
    var user: CooperativePlayer {
        players[userIndex]
    }
    private(set) var currentRound: Int
    var isFirstPlayer: Bool {
        userIndex == 0
    }
    var isLastPlayer: Bool {
        userIndex == players.count - 1
    }
    private var shouldTimerStop = false

    convenience init(from room: GameRoom) {
        self.init(from: room, networkAdapter: GameNetworkAdapter(roomCode: room.roomCode))
    }

    init(from room: GameRoom, networkAdapter: GameNetworkAdapter) {
        self.roomCode = room.roomCode
        self.networkAdapter = networkAdapter
        let sortedRoomPlayers = room.players.sorted()
        self.players = []
        for i in 0..<sortedRoomPlayers.count {
            self.players.append(CooperativePlayer(from: sortedRoomPlayers[i], index: i))
        }
        let userUID = NetworkHelper.getLoggedInUserID()
        self.userIndex = self.players.firstIndex(where: { $0.uid == userUID }) ?? 0
        self.currentRound = 1
    }

    func addUsersDrawing(image: UIImage) {
        user.addDrawing(image: image)
        networkAdapter.uploadUserDrawing(image: image, forRound: currentRound)
    }

    func downloadMyDrawing() {
        downloadDrawing(of: user)
    }

    func downloadPreviousDrawings() {
        allDrawings = []
        let previousPlayers = players.filter { $0.index < userIndex }
        previousPlayers.forEach { downloadDrawing(of: $0) }
    }

    func setCurrentPlayer() {
        networkAdapter.setCurrentPlayer(from: user.uid, to: user.uid, in: currentRound)
    }

    func setNextPlayer() {
        if userIndex == players.count - 1 {
            // User is last player
            networkAdapter.endGame()
            viewingDelegate?.navigateToEndPage()
            return
        }
        let nextPlayer = players[userIndex + 1]
        networkAdapter.setCurrentPlayer(from: user.uid, to: nextPlayer.uid, in: currentRound)
    }

    func waitForTurn() {
        networkAdapter.observeTurnArrive(for: user.uid, completionHandler: {
            self.delegate?.changeMessageToGetReady()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.delegate?.navigateToDrawingPage()
            }
        })
    }

    func downloadSubsequentDrawings() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.shouldTimerStop {
                timer.invalidate()
            }
            let numberOfDrawings = self.allDrawings.count
            self.networkAdapter.downloadCurrentPlayerDrawing(
                forRound: self.currentRound, completionHandler: { [weak self] image in
                    if numberOfDrawings == 0 {
                        self?.allDrawings.append(image)
                    } else {
                        self?.allDrawings[numberOfDrawings - 1] = image
                    }
                    self?.viewingDelegate?.updateDrawings()
                }
            )
        }
    }

    func observeGameStatus() {
        networkAdapter.observeGameStatus(completionHandler: {
            print("game ended")
            self.shouldTimerStop = true
            self.viewingDelegate?.navigateToEndPage()
        })
    }

    func downloadDrawing(of player: CooperativePlayer) {
        print("downloading for \(player.uid)")
        networkAdapter.waitAndDownloadPlayerDrawing(
            playerUID: player.uid, forRound: currentRound, completionHandler: { [weak self] image in
                self?.allDrawings.append(image)
            }
        )
    }

    func navigateIfUserIsNextPlayer(currentPlayer: CooperativePlayer) {
        if currentPlayer.index + 1 == userIndex {
            self.delegate?.changeMessageToGetReady()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.delegate?.navigateToDrawingPage()
            }
        }
    }

    func navigateIfPlayerIsLast(currentPlayer: CooperativePlayer) {
        if currentPlayer.index + 1 == players.count {
            self.viewingDelegate?.navigateToEndPage()
        }
    }
}
