//
//  WhiteGradientIndicatorView.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 23/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class WhiteGradientIndicatorView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        layer.borderWidth = 2
        layer.borderColor = #colorLiteral(red: 0.9198423028, green: 0.9198423028, blue: 0.9198423028, alpha: 0.8).cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.5
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.width / 2
    }

}
