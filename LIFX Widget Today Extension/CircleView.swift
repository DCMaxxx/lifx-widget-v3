//
//  CircleView.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 03/03/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class CircleView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.width / 2
    }

}
