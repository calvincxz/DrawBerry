//
//  ClassGameNetworkAdapter.swift
//  DrawBerry
//
//  Created by See Zi Yang on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Firebase
import FirebaseStorage

class GameNetworkAdapter {
    let roomCode: RoomCode
    let db: DatabaseReference
    let cloud: StorageReference

    init(roomCode: RoomCode) {
        self.roomCode = roomCode
        self.db = Database.database().reference()
        self.cloud = Storage.storage().reference()
    }

    // TODO: delete room from active room (in both db and cloud) when game room ends

    func uploadUserDrawing(image: UIImage, forRound round: Int) {
        guard let imageData = image.pngData() else {
            return
        }

        let userID = NetworkHelper.getLoggedInUserID()

        let dbPathRef = db.child("activeRooms")
            .child(roomCode.type.rawValue).child(roomCode.value).child("players")
            .child(userID).child("rounds").child(String(round)).child("hasUploadedImage")
        let cloudPathRef = cloud.child("activeRooms")
            .child(roomCode.type.rawValue).child(roomCode.value).child("players")
            .child(userID).child("\(round).png")

        cloudPathRef.putData(imageData, metadata: nil, completion: { _, error in
            if let error = error {
                // TODO: Handle error, count as player left?
                print("Error \(error) occured while uploading user drawing to CloudStorage")
                return
            }

            dbPathRef.setValue(true)
        })
    }

    private func downloadPlayerDrawing(playerUID: String, forRound round: Int,
                                       completionHandler: @escaping (UIImage) -> Void) {
        let cloudPathRef = cloud.child("activeRooms")
            .child(roomCode.type.rawValue).child(roomCode.value).child("players")
            .child(playerUID).child("\(round).png")

        cloudPathRef.getData(maxSize: 10 * 1_024 * 1_024, completion: { data, error in
            if let error = error {
                print("Error \(error) occured while downloading player drawing")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                return
            }

            completionHandler(image)
        })
    }

    func waitAndDownloadPlayerDrawing(playerUID: String, forRound round: Int,
                                      completionHandler: @escaping (UIImage) -> Void) {
        let dbPathRef = db.child("activeRooms")
            .child(roomCode.type.rawValue).child(roomCode.value).child("players")
            .child(playerUID).child("rounds").child(String(round)).child("hasUploadedImage")

        dbPathRef.observe(.value, with: { snapshot in
            guard snapshot.value as? Bool ?? false else { // image not uploaded yet
                return
            }

            self.downloadPlayerDrawing(playerUID: playerUID, forRound: round,
                                       completionHandler: completionHandler)

            dbPathRef.removeAllObservers() // remove observer after downloading image
        })
    }

    func setCurrentPlayer(from previousUID: String, to playerUID: String, in round: Int) {
        let previousPlayerRef = db.child("activeRooms")
            .child(roomCode.type.rawValue).child(roomCode.value).child("players")
            .child(previousUID).child("rounds").child(String(round)).child("hasUploadedImage")
        previousPlayerRef.removeAllObservers()

        let currentPlayerRef = db.child("activeRooms")
            .child(roomCode.type.rawValue).child(roomCode.value).child("currentPlayer")
        currentPlayerRef.setValue(playerUID)
    }

    func endGame() {
        let currentStatusRef = db.child("activeRooms")
            .child(roomCode.type.rawValue).child(roomCode.value).child("isEnded")
        currentStatusRef.setValue(true)
    }

    func observeTurnArrive(for playerUID: String, completionHandler: @escaping () -> Void) {
        let currentPlayerRef = db.child("activeRooms")
            .child(roomCode.type.rawValue).child(roomCode.value).child("currentPlayer")

        currentPlayerRef.observe(.value, with: { snapshot in
            guard let currentUID = snapshot.value as? String else {
                return
            }
            if currentUID != playerUID {
                return
            }
            completionHandler()
            currentPlayerRef.removeAllObservers() // remove observer after turn is reached
        })
    }

    func observeGameStatus(completionHandler: @escaping () -> Void) {
        let currentStatusRef = db.child("activeRooms")
            .child(roomCode.type.rawValue).child(roomCode.value).child("isEnded")

        currentStatusRef.observe(.value, with: { snapshot in
            guard snapshot.value as? Bool ?? false else { // game not ended yet
                return
            }
            completionHandler()
            currentStatusRef.removeAllObservers()
        })
    }

    func downloadCurrentPlayerDrawing(forRound round: Int, completionHandler: @escaping (UIImage) -> Void) {
        let currentPlayerRef = db.child("activeRooms")
            .child(roomCode.type.rawValue).child(roomCode.value).child("currentPlayer")

        currentPlayerRef.observe(.value, with: { snapshot in
            guard let currentUID = snapshot.value as? String else { // image not uploaded yet
                return
            }

            self.downloadPlayerDrawing(playerUID: currentUID, forRound: round,
                                       completionHandler: completionHandler)

            currentPlayerRef.removeAllObservers() // remove observer after downloading image
        })
    }
}
