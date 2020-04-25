//
//  GameNetwork.swift
//  DrawBerry
//
//  Created by See Zi Yang on 14/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

protocol GameNetwork: NetworkInterface {
    var roomCode: RoomCode { get }

    func uploadUserDrawing(image: UIImage, forRound round: Int)

    func observeAndDownloadPlayerDrawing(playerUID: String, forRound round: Int,
                                         completionHandler: @escaping (UIImage) -> Void)

    func endGame(isRoomMaster: Bool, numRounds: Int)
}
