//
//  ClassicGameNetwork.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 25/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

protocol ClassicGameNetwork: NetworkInterface {
    func setTopic(topic: String, forRound round: Int)

    func observeTopic(forRound round: Int, completionHandler: @escaping (String) -> Void)
    
    func userVoteFor(playerUID: String, forRound round: Int,
                     updatedPlayerPoints: Int, updatedUserPoints: Int?)

    func observePlayerVote(playerUID: String, forRound round: Int,
                           completionHandler: @escaping (String) -> Void)

}
