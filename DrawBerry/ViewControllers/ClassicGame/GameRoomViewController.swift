//
//  GameRoomViewController.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class GameRoomViewController: UIViewController, GameRoomDelegate {
    var room: GameRoom!

    @IBOutlet private weak var playersCollectionView: UICollectionView!

    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 160.0, bottom: 50.0, right: 160.0)
    private let itemsPerRow: CGFloat = 2

    /// Hides the status bar at the top
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        playersCollectionView.delegate = self
        playersCollectionView.dataSource = self
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let classicVC = segue.destination as? ClassicViewController {
            classicVC.classicGame = ClassicGame(from: room)
        }
    }

    @IBAction private func backOnTap(_ sender: UIBarButtonItem) {
        leaveGameRoom()
    }

    @IBAction private func startOnTap(_ sender: UIBarButtonItem) {
        startGame()
    }

    func playersDidUpdate() {
        playersCollectionView.reloadData()
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
        performSegue(withIdentifier: "segueToClassicGame", sender: self)
    }
}

extension GameRoomViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GameRoom.maxPlayers
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = getReusableCell(for: indexPath)

        guard indexPath.row < room.players.count else {
            return cell
        }

        let player = room.players[indexPath.row]

        // Truncate uid for testing
        let username = String(player.name.prefix(10))

        UserProfileNetworkAdapter.downloadProfileImage(delegate: cell, playerUID: player.uid)

        cell.setUsername(username)

        return cell
    }

    private func getReusableCell(for indexPath: IndexPath) -> PlayerCollectionViewCell {
        guard let cell = playersCollectionView.dequeueReusableCell(
            withReuseIdentifier: "playerCell", for: indexPath) as? PlayerCollectionViewCell else {
                fatalError("Unable to get reusable cell.")
        }
        cell.setCircularShape()
        cell.setDefaultImage()
        cell.setUsername("Empty Slot")
        return cell
    }
}

// Code for layout adapted from https://www.raywenderlich.com/9334-uicollectionview-tutorial-getting-started
extension GameRoomViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = playersCollectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

/// Handles gestures for `GameRoomViewController`
extension GameRoomViewController {

    /// Loads the user profile when single tap is detected on a specific cell.
    @IBAction private func handleSingleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: playersCollectionView)
        guard let indexPath = playersCollectionView.indexPathForItem(at: location) else {
            return
        }

        // Disable gestures on empty slots
        guard indexPath.row < room.players.count else {
            return
        }
        openUserProfile(at: indexPath.row)
    }

    // TODO:
    private func openUserProfile(at index: Int) {
        let alert = UIAlertController(title: "Profile", message: "Opened user profile", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
