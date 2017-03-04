//
//  BrigthnessCollectionViewCell.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 03/03/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class BrightnessCollectionViewCell: UICollectionViewCell, Identifiable {

    @IBOutlet private weak var imageView: UIImageView!

    override func tintColorDidChange() {
        super.tintColorDidChange()

        imageView.tintColor = tintColor
    }

    func configure(with brightness: Brightness, tint: UIColor) {
        tintColor = tint
        imageView.image = brightness.icon
    }

}
