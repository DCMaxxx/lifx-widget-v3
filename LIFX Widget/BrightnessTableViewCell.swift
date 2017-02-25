//
//  BrightnessTableViewCell.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 25/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class BrightnessTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconView: UIImageView!

    func configure(with brightness: Brightness) {
        titleLabel.text = "\(Int(brightness.value * 100)) %"
        iconView.image = brightness.icon
        iconView.tintColor = #colorLiteral(red: 0.1326085031, green: 0.1326085031, blue: 0.1326085031, alpha: 1) // for some reason, this is not taken into account when set in IB
    }

}
