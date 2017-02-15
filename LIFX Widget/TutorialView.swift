//
//  TutorialView.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 15/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit

final class TutorialView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.bounds.width / 15
    }

}
