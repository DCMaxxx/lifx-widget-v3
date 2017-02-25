//
//  UppercasedLabel.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 25/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class UppercasedLabel: UILabel {

    override var text: String? {
        didSet {
            super.text = text?.uppercased()
        }
    }

}

final class UppercasedButton: UIButton {

    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title?.uppercased(), for: state)
    }

}

final class UppercasedBarButtonItem: UIBarButtonItem {

    override var title: String? {
        didSet {
            super.title = title?.uppercased()
        }
    }

}
