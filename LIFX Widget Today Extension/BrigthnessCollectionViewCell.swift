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

    func configure(with brightness: Brightness, tintColor: UIColor) {
        imageView.image = brightness.icon
        imageView.tintColor = tintColor
    }

}
