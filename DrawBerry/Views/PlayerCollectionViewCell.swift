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
        let size = frame.size
        let renderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        profilePicture.image = resizedImage
    }

    func setDefaultImage() {
        let testImage = #imageLiteral(resourceName: "grey")
        let size = frame.size
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            testImage.draw(in: CGRect(origin: .zero, size: size))
        }
        profilePicture.image = image
    }

    func setUsername(_ text: String) {
        usernameLabel.text = text
    }
}
