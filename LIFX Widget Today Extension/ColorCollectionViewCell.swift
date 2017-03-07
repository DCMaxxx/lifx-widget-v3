//
//  ColorCollectionViewCell.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 07/03/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell, Identifiable {

    func configure(with color: Color) {
        contentView.backgroundColor = color.displayColor
    }

}
