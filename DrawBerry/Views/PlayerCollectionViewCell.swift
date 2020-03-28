//
//  PlayerCollectionViewCell.swift
//  DrawBerry
//
//  Created by Calvin Chen on 28/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class PlayerCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var profilePicture: UIImageView!
    
    func setImage(_ image: UIImage) {
        profilePicture.image = image
    }

    func setDefaultImage() {
        //profilePicture.image =
    }



    func setUsername(_ text: String) {
        usernameLabel.text = text
    }
}
