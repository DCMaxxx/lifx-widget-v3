//
//  TargetTableViewCell.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 28/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class TargetTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!

    func configure(with target: Target) {
        titleLabel.text = target.name
    }

}
