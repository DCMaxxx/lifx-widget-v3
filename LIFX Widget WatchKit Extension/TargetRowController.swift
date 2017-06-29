//
//  TargetRowController.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 29/06/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import WatchKit
import Foundation

class TargetRowController: NSObject, Identifiable {

    @IBOutlet private var nameLabel: WKInterfaceLabel!

    func configure(with target: Target) {
        nameLabel.setText(target.name)
    }

}
