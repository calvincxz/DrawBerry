//
//  TeamBattleGameNetwork.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 25/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

protocol TeamBattleGameNetwork: NetworkInterface {
    func observeValue(key: String, playerUID: String,
                      completionHandler: @escaping (String) -> Void)

    func uploadKeyValuePair(key: String, playerUID: String, value: String)

}
