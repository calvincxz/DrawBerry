//
//  CooperativeGameRoomViewController.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class CooperativeGameRoomViewController: UIViewController, GameRoomDelegate {
    var room: GameRoom!

    @IBOutlet private weak var playersTableView: UITableView!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let waitingVC = segue.destination as? WaitingViewController {
            waitingVC.cooperativeGame = CooperativeGame(from: room)
            waitingVC.cooperativeGame.waitForPreviousPlayerToFinish()
        }
    }

    @IBAction private func backOnTap(_ sender: UIBarButtonItem) {
        leaveGameRoom()
    }

    @IBAction private func startOnTap(_ sender: UIBarButtonItem) {
        startGame()
    }

    func playersDidUpdate() {
        playersTableView.reloadData()
    }

    func gameHasStarted() {
        segueToGameVC()
    }

    private func leaveGameRoom() {
        room.leaveRoom()

        dismiss(animated: true, completion: nil)
    }

    private func startGame() {
        // TODO: make only roomMaster can startGame?

        if !room.canStart {
            // TODO: show some UIPrompt indicating minPlayer amount not reached
            return
        }

        room.startGame()
        segueToGameVC()
    }

    private func segueToGameVC() {
        performSegue(withIdentifier: "segueToCooperativeGame", sender: self)
    }
}

extension CooperativeGameRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return room.players.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playersTableView.dequeueReusableCell(withIdentifier: "cooperativePlayerCell", for: indexPath)
        cell.textLabel?.text = room.players[indexPath.row].name
        return cell
    }

}
