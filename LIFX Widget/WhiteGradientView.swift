//
//  WhiteGradientView.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 23/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class WhiteGradientView: UIView {

    fileprivate let gradientLayer = CAGradientLayer()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        gradientLayer.colors = [UIColor(kelvin: Int.minLifxKelvin).cgColor,
                                UIColor(kelvin: Int.maxLifxKelvin).cgColor]
        layer.addSublayer(gradientLayer)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1 / UIScreen.main.scale
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds
    }

}
