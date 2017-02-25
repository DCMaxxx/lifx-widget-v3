//
//  TargetsReorderTableViewCell.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 25/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class TargetsReorderTableViewCell: UITableViewCell {

    func configure(with target: Target) {
        textLabel?.text = target.name
    }

}
