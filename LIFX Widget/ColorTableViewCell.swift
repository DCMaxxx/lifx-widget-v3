//
//  ColorTableViewCell.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 20/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class ColorTableViewCell: UITableViewCell, Identifiable {

    func configure(with color: Color) {
        backgroundColor = color.displayColor
    }

}
